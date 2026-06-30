{ config, pkgs, lib, ... }:

{
  systemd.services.duckdns-update = {
    description = "Update DuckDNS IP";
    serviceConfig = {
      Type = "oneshot";
      EnvironmentFile = "/etc/duckdns/token";
      ExecStart = pkgs.writeShellScript "duckdns-update" ''
        ${pkgs.curl}/bin/curl -s \
          "https://www.duckdns.org/update?domains=${lib.concatStringsSep "," config.myOptions.duckdns.domains}&token=$DUCKDNS_TOKEN&ip=" \
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
}
