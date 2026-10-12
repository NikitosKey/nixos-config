{ pkgs, ... }:

let
  gbPreviewSite = pkgs.buildNpmPackage {
    pname = "gbpreview-site";
    version = "0.1.0";
    src = ../gbpreview-site;
    npmDepsHash = "sha256-ZgSyvCes3un85yRU3cdLwBrzV9mUGgaTjPGVTbRgzwQ=";
    nodejs = pkgs.nodejs_22;

    installPhase = ''
      mkdir -p $out
      cp -r dist node_modules package.json $out/
    '';
  };
in
{
  myOptions.duckdns.domains = [ "gbpreview" ];

  systemd.services.gbpreview-site = {
    description = "Garant Bezopasnosti preview site";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      DynamicUser = true;
      WorkingDirectory = "${gbPreviewSite}";
      Environment = [
        "NODE_ENV=production"
        "HOST=127.0.0.1"
        "PORT=4321"
      ];
      ExecStart = "${pkgs.nodejs_22}/bin/node ${gbPreviewSite}/dist/server/entry.mjs";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };

  services.nginx.virtualHosts."gbpreview.duckdns.org" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:4321";
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
