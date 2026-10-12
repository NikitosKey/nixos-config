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

  gbPreviewImage = pkgs.dockerTools.buildLayeredImage {
    name = "gbpreview-site";
    tag = "latest";
    contents = [ pkgs.nodejs_22 gbPreviewSite ];
    config = {
      Cmd = [ "${pkgs.nodejs_22}/bin/node" "${gbPreviewSite}/dist/server/entry.mjs" ];
      Env = [
        "NODE_ENV=production"
        "HOST=0.0.0.0"
        "PORT=4321"
      ];
      ExposedPorts = { "4321/tcp" = {}; };
    };
  };
in
{
  myOptions.duckdns.domains = [ "gbpreview" ];

  virtualisation.oci-containers.backend = "podman";
  virtualisation.oci-containers.containers.gbpreview = {
    image = "gbpreview-site:latest";
    imageFile = gbPreviewImage;
    ports = [ "127.0.0.1:4321:4321" ];
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
