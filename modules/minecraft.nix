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

      networking.nameservers = [ "8.8.8.8" "1.1.1.1" ];

      environment.systemPackages = [ pkgs.mcrcon ];

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
            ${pkgs.zulu21}/bin/java \
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

      systemd.services.minecraft-backup = {
        description = "Minecraft World Backup Service";
        serviceConfig = {
          Type = "oneshot";
          User = "minecraft";
          Group = "minecraft";
        };
        script = ''
          BACKUP_DIR="/var/lib/minecraft/backups"
          mkdir -p "$BACKUP_DIR"

          DATE=$(${pkgs.coreutils}/bin/date +%Y-%m-%d_%H-%M-%S)
          echo "Starting backup of minecraft world..."
          ${pkgs.gnutar}/bin/tar -czf "$BACKUP_DIR/world_$DATE.tar.gz" -C /var/lib/minecraft world
          echo "Backup created: world_$DATE.tar.gz"

          ${pkgs.findutils}/bin/find "$BACKUP_DIR" -name "world_*.tar.gz" -mtime +7 -delete
          echo "Old backups cleaned up."
        '';
      };

      systemd.timers.minecraft-backup = {
        description = "Timer for Minecraft World Backup";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "04:00:00";
          Persistent = true;
        };
      };
    };
  };
}
