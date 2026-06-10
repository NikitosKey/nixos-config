# hosts/orangepi/frpc.nix
{ config, pkgs, ... }:

{
  services.frp = {
    instances.client = {
      enable = true;
      role = "client";

      settings = {
        serverAddr = "159.194.214.57";
        serverPort = 7000;

        auth = {
          method = "token";
          token = "AHAHAHAH_SOSAL?!";
        };

        transport = {
          protocol = "quic";
        };

        proxies = [
          {
            name = "minecraft-tcp";
            type = "tcp";
            localIP = "127.0.0.1";
            localPort = 25565;
            remotePort = 25565;
          }
          {
            name = "minecraft-udp";
            type = "udp";
            localIP = "127.0.0.1";
            localPort = 24454;
            remotePort = 24454;
          }
        ];
      };
    };
  };
}
