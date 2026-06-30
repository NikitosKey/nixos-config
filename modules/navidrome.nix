{ config, ... }:

{
  myOptions.duckdns.domains = [ "sosalmu" ];

  sops.secrets."lastfm/api_key" = {};
  sops.secrets."lastfm/secret"  = {};

  sops.templates."navidrome-lastfm.env".content = ''
    ND_LASTFM_APIKEY=${config.sops.placeholder."lastfm/api_key"}
    ND_LASTFM_SECRET=${config.sops.placeholder."lastfm/secret"}
  '';

  virtualisation.oci-containers.backend = "podman";

  virtualisation.oci-containers.containers.navidrome = {
    image = "deluan/navidrome:latest";
    ports = [ "127.0.0.1:4533:4533" ];
    volumes = [
      "/var/lib/navidrome/data:/data"
      "/var/lib/navidrome/music:/music:ro"
    ];
    environmentFiles = [ config.sops.templates."navidrome-lastfm.env".path ];
    environment = {
      ND_MUSICFOLDER = "/music";
      ND_DATAFOLDER = "/data";
      ND_LOGLEVEL = "info";
      ND_LASTFM_ENABLED = "true";
      HTTP_PROXY  = "socks5://10.88.0.1:10808";
      HTTPS_PROXY = "socks5://10.88.0.1:10808";
      NO_PROXY    = "localhost,127.0.0.1";
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/navidrome/data  0750 root root -"
    "d /var/lib/navidrome/music 0750 root root -"
  ];

  services.nginx.virtualHosts."sosalmu.duckdns.org" = {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
      proxyPass = "http://127.0.0.1:4533";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
      '';
    };
  };
}
