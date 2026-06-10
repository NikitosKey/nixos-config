# hosts/orangepi/frpc.nix
{ config, pkgs, ... }:

{
  services.frpc = {
    enable = true;

    settings = {
      serverAddr = "159.194.214.57";
      serverPort = 7000;

    uth = {
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
          localPort = 25564;
          remotePort = 24454;
        }
      ];
    };
  };
}
