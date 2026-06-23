{ config, pkgs, lib, ... }:

{
  # CouchDB только на localhost — снаружи через nginx
  services.couchdb = {
    enable = true;
    port = 5984;
    bindAddress = "127.0.0.1";

    extraConfig = {
      chttpd = {
        bind_address = "127.0.0.1";
        port = "5984";
      };
      httpd = {
        enable_cors = "true";
      };
      cors = {
        origins = "app://obsidian.md, capacitor://localhost, http://localhost";
        credentials = "true";
        headers = "accept, authorization, content-type, origin, referer";
        methods = "GET, PUT, POST, HEAD, DELETE";
      };
      chttpd_auth = {
        require_valid_user = "true";
      };
    };
  };

  # Записываем пароль из SOPS в local.d/admins.ini перед стартом CouchDB
  systemd.services.couchdb.serviceConfig.ExecStartPre = lib.mkAfter [
    ("+${pkgs.writeShellScript "couchdb-set-admin" ''
      LOCAL_INI=/var/lib/couchdb/local.ini
      PASS=$(cat ${config.sops.secrets."couchdb/admin_password".path})
      # удаляем старую секцию [admins] если есть, добавляем свежую
      sed -i '/^\[admins\]/,/^\[/{/^\[admins\]/d;/^admin\s*=/d}' "$LOCAL_INI" 2>/dev/null || true
      printf '\n[admins]\nadmin = %s\n' "$PASS" >> "$LOCAL_INI"
      chown couchdb:couchdb "$LOCAL_INI"
    ''}")
  ];

  # Let's Encrypt через HTTP-01 challenge (nginx сам обрабатывает)
  security.acme = {
    acceptTerms = true;
    defaults.email = "nikitwww@gmail.com";
  };

  services.nginx = {
    enable = true;

    virtualHosts."sosalfs.duckdns.org" = {
      enableACME = true;
      forceSSL = true;

      locations."/" = {
        proxyPass = "http://127.0.0.1:5984";
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Forwarded-For $remote_addr;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };
  };

  # Автообновление IP на DuckDNS каждые 5 минут
  # Токен кладёшь в /etc/duckdns/token в формате: DUCKDNS_TOKEN=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
  systemd.services.duckdns-update = {
    description = "Update DuckDNS IP for sosalfs";
    serviceConfig = {
      Type = "oneshot";
      EnvironmentFile = "/etc/duckdns/token";
      ExecStart = pkgs.writeShellScript "duckdns-update" ''
        ${pkgs.curl}/bin/curl -s \
          "https://www.duckdns.org/update?domains=sosalfs,sosalnc,sosalph&token=$DUCKDNS_TOKEN&ip=" \
          -o /tmp/duckdns.log
        cat /tmp/duckdns.log
      '';
    };
  };

  systemd.timers.duckdns-update = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "1min";
      OnUnitActiveSec = "5min";
      Persistent = true;
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
