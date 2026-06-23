{ config, ... }:

{
  services.immich = {
    enable = true;
    host = "127.0.0.1";
    port = 2283;
    mediaLocation = "/var/lib/immich/media";
    database.enable = true;
    database.createDB = true;
    redis.enable = true;
  };

  services.nginx.virtualHosts."sosalph.duckdns.org" = {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
      proxyPass = "http://127.0.0.1:2283";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        client_max_body_size 50G;
        proxy_read_timeout 600s;
        proxy_send_timeout 600s;
      '';
    };
  };
}
