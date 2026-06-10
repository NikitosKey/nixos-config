{ config, pkgs, ... }:

{
  networking.firewall = {
    allowedTCPPorts = [ 25565 ];
    allowedUDPPorts = [ 24454 ];
  };

  containers.minecraft-server = {
    autoStart = true;

    forwardPorts = [
      { protocol = "tcp"; hostPort = 25565; containerPort = 25565; }
      { protocol = "udp"; hostPort = 24454; containerPort = 24454; }
    ];

    config = { config, pkgs, ... }: {

      nixpkgs.config.allowUnfree = true;

      users.users.minecraft = {
        isSystemUser = true;
        group = "minecraft";
        home = "/var/lib/minecraft";
        createHome = true;
      };
      users.groups.minecraft = {};

      networking.firewall = {
        allowedTCPPorts = [ 25565 ];
        allowedUDPPorts = [ 24454 ];
      };

      systemd.services.minecraft-server = {
        description = "Minecraft Fabric Server (1.20.1)";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        serviceConfig = {
          Type = "simple";
          User = "minecraft";
          Group = "minecraft";
          WorkingDirectory = "/var/lib/minecraft";

          ExecStart = ''
            ${pkgs.zulu17}/bin/java \
              -Xms10G -Xmx10G \
              -XX:+UseG1GC \
              -XX:+ParallelRefProcEnabled \
              -XX:MaxGCPauseMillis=200 \
              -XX:+UnlockExperimentalVMOptions \
              -XX:+DisableExplicitGC \
              -XX:+AlwaysPreTouch \
              -XX:G1NewSizePercent=30 \
              -XX:G1MaxNewSizePercent=40 \
              -XX:G1HeapRegionSize=8m \
              -XX:G1ReservePercent=20 \
              -XX:G1HeapWastePercent=5 \
              -XX:G1MixedGCCountTarget=4 \
              -XX:InitiatingHeapOccupancyPercent=15 \
              -XX:G1MixedGCLiveThresholdPercent=90 \
              -XX:G1RSetUpdatingPauseTimePercent=5 \
              -XX:SurvivorRatio=32 \
              -XX:+PerfDisableSharedMem \
              -XX:MaxTenuringThreshold=1 \
              -jar fabric-server-launch.jar nogui
          '';

          Restart = "always";
          TimeoutStopSec = "60";
        };
      };
    };
  };
}
