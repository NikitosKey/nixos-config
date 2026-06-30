{ config, pkgs, ... }:

{
  myOptions.duckdns.domains = [ "sosalnc" ];

  services.nextcloud = {
    enable = true;
    hostName = "sosalnc.duckdns.org";
    https = true;
    package = pkgs.nextcloud33;

    database.createLocally = true;

    config = {
      dbtype = "pgsql";
      adminpassFile = config.sops.secrets."nextcloud/admin_password".path;
    };

    settings = {
      default_phone_region = "RU";
      trusted_proxies = [ "127.0.0.1" ];
    };

    configureRedis = true;
    maxUploadSize = "10G";
  };

  services.nginx.virtualHosts."sosalnc.duckdns.org" = {
    enableACME = true;
    forceSSL = true;
  };
}
