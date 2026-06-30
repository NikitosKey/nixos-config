{ config, pkgs, ... }:

{
  myOptions.duckdns.domains = [ "sosalmc" ];

  services.nginx.virtualHosts."sosalmc.duckdns.org" = {
    enableACME = true;
    forceSSL = true;
    root = "/var/www/modpack";
    extraConfig = ''
      autoindex on;
      add_header Access-Control-Allow-Origin "*" always;
      add_header Cache-Control "no-cache, no-store, must-revalidate" always;
    '';
  };

  systemd.tmpfiles.rules = [
    "d /var/www/modpack 0775 ${config.myOptions.username} nginx -"
  ];
}
