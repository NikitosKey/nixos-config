{ config, pkgs, lib, ... }:

let
  geoBaseUrl = "https://access.sosal-da.net/incy";

  xray-select = pkgs.writeScript "xray-select.py" ''
    import sys, json, os

    config_path = sys.argv[1]
    json_path = sys.argv[2]
    pick = sys.argv[3] if len(sys.argv) > 3 else ""

    with open(json_path) as f:
        data = json.load(f)

    # Remnawave returns array of configs, one per server
    configs = data if isinstance(data, list) else [data]

    if not configs:
        print("No configs found.")
        sys.exit(1)

    print("\nAvailable servers:")
    for i, cfg in enumerate(configs, 1):
        name = cfg.get("remarks", f"Server {i}")
        print(f"  [{i}] {name}")

    if pick:
        choice = int(pick)
    else:
        print("")
        choice = int(input(f"Select server [1-{len(configs)}]: "))

    selected = configs[choice - 1]

    tun_inbound = {
        "protocol": "tun",
        "settings": {
            "autoOutboundsInterface": "auto",
            "autoSystemRoutingTable": ["0.0.0.0/0", "::/0"],
            "dns": ["1.1.1.1", "8.8.8.8"],
            "gateway": ["10.0.0.1/16", "fc00::1/64"],
            "mtu": 1280,
            "name": "xray0",
            "userLevel": 0
        }
    }

    inbounds = selected.get("inbounds", [])
    inbounds = [ib for ib in inbounds if ib.get("protocol") != "tun"]
    inbounds.append(tun_inbound)
    selected["inbounds"] = inbounds

    # Make inbounds listen on all interfaces so podman/LAN can reach them
    for ib in selected.get("inbounds", []):
        if ib.get("listen") == "127.0.0.1":
            ib["listen"] = "0.0.0.0"

    os.makedirs(os.path.dirname(config_path), exist_ok=True)
    with open(config_path, "w") as f:
        json.dump(selected, f, ensure_ascii=False, indent=2)

    print(f"\nSwitched to: {selected.get('remarks', 'Server ' + str(choice))}")
  '';

  xray-geo-fetch = pkgs.writeShellScript "xray-geo-fetch" ''
    HWID=$(cat /etc/machine-id)
    GEO_DIR=/var/lib/xray
    mkdir -p "$GEO_DIR"

    for name in geoip geosite; do
      TMP=$(mktemp)
      if ${pkgs.curl}/bin/curl -sf --max-time 60 \
          "${geoBaseUrl}/$name.dat?hwid=$HWID" -o "$TMP" \
          && [ -s "$TMP" ]; then
        mv "$TMP" "$GEO_DIR/$name.dat"
        echo "xray-geo: updated $name.dat"
      else
        rm -f "$TMP"
        echo "xray-geo: failed to fetch $name.dat, keeping existing"
      fi
    done

    # Bootstrap from nixpkgs if still missing
    if [ ! -f "$GEO_DIR/geoip.dat" ]; then
      cp ${pkgs.v2ray-geoip}/share/v2ray/geoip.dat "$GEO_DIR/geoip.dat"
      echo "xray-geo: bootstrapped geoip.dat from nixpkgs"
    fi
    if [ ! -f "$GEO_DIR/geosite.dat" ]; then
      cp ${pkgs.v2ray-domain-list-community}/share/v2ray/geosite.dat "$GEO_DIR/geosite.dat"
      echo "xray-geo: bootstrapped geosite.dat from nixpkgs"
    fi
  '';

  xray-config-fetch = pkgs.writeShellScript "xray-config-fetch" ''
    CONFIG=/etc/xray/config.json
    if [ ! -f "$CONFIG" ]; then
      SUB_URL=$(cat ${config.sops.secrets."remnawave/sub_url".path})
      HWID=$(cat /etc/machine-id)
      TMPJSON=$(mktemp /tmp/xray-init-XXXXXX.json)
      ${pkgs.curl}/bin/curl -sf --noproxy '*' --max-time 15 \
          "$SUB_URL/json?hwid=$HWID" -o "$TMPJSON" \
        && ${pkgs.python3}/bin/python3 ${xray-select} "$CONFIG" "$TMPJSON" "1" \
        || true
      rm -f "$TMPJSON"
    fi
  '';

  xray-cleanup = pkgs.writeShellScript "xray-cleanup" ''
    # Удаляем TUN-интерфейс если поддерживается (ядро может быть собрано без netlink)
    ${pkgs.iproute2}/bin/ip link delete xray0 2>/dev/null || true

    # Удаляем policy-routing rules с приоритетом < 100
    # ip rule list может вернуть ошибку если RTNETLINK не поддерживается — игнорируем
    RULES=$(${pkgs.iproute2}/bin/ip rule list 2>/dev/null) || true
    if [ -n "$RULES" ]; then
      echo "$RULES" \
        | ${pkgs.gawk}/bin/awk -F: '$1+0 < 100 {print $1+0}' \
        | while read -r pref; do
            ${pkgs.iproute2}/bin/ip rule del pref "$pref" 2>/dev/null || true
          done
    fi
  '';

  xray-switch = pkgs.writeShellScriptBin "xray" ''
    set -e
    SUB_URL=$(cat ${config.sops.secrets."remnawave/sub_url".path})
    HWID=$(cat /etc/machine-id)
    CONFIG_PATH=/etc/xray/config.json
    TMPJSON=$(mktemp /tmp/xray-sub-XXXXXX.json)
    trap "rm -f $TMPJSON" EXIT

    ACTION="''${1:-pick}"

    case "$ACTION" in
      update)
        echo "Fetching config from Remnawave..."
        ${pkgs.curl}/bin/curl -sf --noproxy '*' --max-time 15 \
            "$SUB_URL/json?hwid=$HWID" -o "$TMPJSON"
        ${pkgs.python3}/bin/python3 ${xray-select} "$CONFIG_PATH" "$TMPJSON" "1"
        systemctl restart xray
        echo "Done. Xray restarted (server 1)."
        ;;

      pick)
        echo "Fetching server list..."
        ${pkgs.curl}/bin/curl -sf --noproxy '*' --max-time 15 \
            "$SUB_URL/json?hwid=$HWID" -o "$TMPJSON"
        ${pkgs.python3}/bin/python3 ${xray-select} "$CONFIG_PATH" "$TMPJSON" "''${2:-}"
        systemctl restart xray
        echo "Xray restarted."
        ;;

      edit)
        ''${EDITOR:-nano} "$CONFIG_PATH"
        systemctl restart xray
        echo "Xray restarted."
        ;;

      stop)
        systemctl stop xray
        echo "Xray stopped."
        ;;

      status)
        systemctl status xray --no-pager -l
        ;;

      *)
        echo "Usage: xray [update|pick [N]|edit|stop|status]"
        echo "  update    - fetch fresh config (server 1)"
        echo "  pick [N]  - pick a specific server interactively or by number"
        echo "  edit      - edit config in \$EDITOR and restart"
        echo "  stop      - stop xray"
        echo "  status    - show service status"
        ;;
    esac
  '';

in
{
  sops.secrets."remnawave/sub_url" = {};

  environment.systemPackages = [ xray-switch ];

  systemd.services.xray = {
    description = "Xray proxy";
    after = [ "network.target" "sops-nix.service" ];
    wantedBy = [ "multi-user.target" ];
    environment = {
      XRAY_LOCATION_ASSET = "/var/lib/xray";
    };
    serviceConfig = {
      ExecStartPre = [
        "${xray-geo-fetch}"
        "${xray-config-fetch}"
      ];
      ExecStart = "${pkgs.xray}/bin/xray run -config /etc/xray/config.json";
      ExecStopPost = "${xray-cleanup}";
      Restart = "always";
      RestartSec = "2s";
      StartLimitBurst = 0;
      AmbientCapabilities = [ "CAP_NET_ADMIN" "CAP_NET_BIND_SERVICE" ];
      CapabilityBoundingSet = [ "CAP_NET_ADMIN" "CAP_NET_BIND_SERVICE" ];
    };
  };

  systemd.services.xray-update = {
    description = "Update Xray config from Remnawave";
    after = [ "network.target" "sops-nix.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${xray-switch}/bin/xray update";
    };
  };

  systemd.timers.xray-update = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  # Прокси-переменные выставляются динамически при старте шелла,
  # в зависимости от того, запущен ли xray прямо сейчас.
  # Это не ломает шелл при остановленном xray.
  programs.fish.interactiveShellInit = ''
    if systemctl is-active --quiet xray 2>/dev/null
      set -gx http_proxy  "socks5://127.0.0.1:10808"
      set -gx https_proxy "socks5://127.0.0.1:10808"
      set -gx HTTP_PROXY  "socks5://127.0.0.1:10808"
      set -gx HTTPS_PROXY "socks5://127.0.0.1:10808"
      set -gx no_proxy    "localhost,127.0.0.1,::1,95.161.54.220,10.0.0.0/8,192.168.0.0/16"
      set -gx NO_PROXY    "localhost,127.0.0.1,::1,95.161.54.220,10.0.0.0/8,192.168.0.0/16"
    end

    function xray
      set -l action $argv[1]
      if test "$action" = "stop"
        sudo ${xray-switch}/bin/xray stop
        set -ge http_proxy https_proxy HTTP_PROXY HTTPS_PROXY no_proxy NO_PROXY
      else if contains -- "$action" pick update
        sudo ${xray-switch}/bin/xray $argv
        set -gx http_proxy  "socks5://127.0.0.1:10808"
        set -gx https_proxy "socks5://127.0.0.1:10808"
        set -gx HTTP_PROXY  "socks5://127.0.0.1:10808"
        set -gx HTTPS_PROXY "socks5://127.0.0.1:10808"
        set -gx no_proxy    "localhost,127.0.0.1,::1,95.161.54.220,10.0.0.0/8,192.168.0.0/16"
        set -gx NO_PROXY    "localhost,127.0.0.1,::1,95.161.54.220,10.0.0.0/8,192.168.0.0/16"
      else
        sudo ${xray-switch}/bin/xray $argv
      end
    end
  '';

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  networking.firewall.allowedTCPPorts = [ 10808 10809 ];
  networking.firewall.interfaces."podman0".allowedTCPPorts = [ 10808 10809 ];
}
