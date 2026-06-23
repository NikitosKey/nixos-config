{ config, pkgs, lib, ... }:

let
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

    os.makedirs(os.path.dirname(config_path), exist_ok=True)
    with open(config_path, "w") as f:
        json.dump(selected, f, ensure_ascii=False, indent=2)

    print(f"\nSwitched to: {selected.get('remarks', 'Server ' + str(choice))}")
  '';

  xray-switch = pkgs.writeShellScriptBin "xray-switch" ''
    set -e
    SUB_URL=$(cat ${config.sops.secrets."remnawave/sub_url".path})
    CONFIG_PATH=/etc/xray/config.json
    TMPJSON=$(mktemp /tmp/xray-sub-XXXXXX.json)
    trap "rm -f $TMPJSON" EXIT

    ACTION="''${1:-switch}"

    case "$ACTION" in
      update)
        echo "Fetching config from Remnawave..."
        ${pkgs.curl}/bin/curl -sf --max-time 15 "$SUB_URL/json" -o "$CONFIG_PATH"
        systemctl restart xray
        echo "Done. Xray restarted with AUTO routing."
        ;;

      switch)
        echo "Fetching server list..."
        ${pkgs.curl}/bin/curl -sf --max-time 15 "$SUB_URL/json" -o "$TMPJSON"
        ${pkgs.python3}/bin/python3 ${xray-select} "$CONFIG_PATH" "$TMPJSON" "''${2:-}"
        systemctl restart xray
        echo "Xray restarted."
        ;;

      status)
        systemctl status xray --no-pager -l
        ;;

      *)
        echo "Usage: xray-switch [update|switch [N]|status]"
        echo "  update      - fetch fresh config (AUTO routing)"
        echo "  switch [N]  - pick a specific server"
        echo "  status      - show service status"
        ;;
    esac
  '';

in
{
  sops.secrets."remnawave/sub_url" = {};

  environment.systemPackages = [ xray-switch pkgs.xray ];

  systemd.services.xray = {
    description = "Xray proxy";
    after = [ "network.target" "sops-nix.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStartPre = pkgs.writeShellScript "xray-fetch-config" ''
        CONFIG=/etc/xray/config.json
        if [ ! -f "$CONFIG" ]; then
          SUB_URL=$(cat ${config.sops.secrets."remnawave/sub_url".path})
          ${pkgs.curl}/bin/curl -sf --max-time 15 "$SUB_URL/json" -o "$CONFIG" || true
        fi
      '';
      ExecStart = "${pkgs.xray}/bin/xray run -config /etc/xray/config.json";
      Restart = "on-failure";
      RestartSec = "5s";
      AmbientCapabilities = [ "CAP_NET_ADMIN" "CAP_NET_BIND_SERVICE" ];
      CapabilityBoundingSet = [ "CAP_NET_ADMIN" "CAP_NET_BIND_SERVICE" ];
    };
  };

  systemd.services.xray-update = {
    description = "Update Xray config from Remnawave";
    after = [ "network.target" "sops-nix.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${xray-switch}/bin/xray-switch update";
    };
  };

  systemd.timers.xray-update = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  environment.sessionVariables = {
    http_proxy  = "socks5://127.0.0.1:10808";
    https_proxy = "socks5://127.0.0.1:10808";
    HTTP_PROXY  = "socks5://127.0.0.1:10808";
    HTTPS_PROXY = "socks5://127.0.0.1:10808";
    no_proxy    = "localhost,127.0.0.1,::1,95.161.54.220,10.0.0.0/8,192.168.0.0/16";
    NO_PROXY    = "localhost,127.0.0.1,::1,95.161.54.220,10.0.0.0/8,192.168.0.0/16";
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  networking.firewall.allowedTCPPorts = [ 10808 10809 ];
  networking.firewall.interfaces."podman0".allowedTCPPorts = [ 10808 10809 ];
}
