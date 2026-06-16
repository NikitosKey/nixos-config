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

    config = { config, pkgs, ... }: let
      serverDir = "/var/lib/minecraft/hbm_1.7.10";
    in {

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
          WorkingDirectory = serverDir;

          ExecStart = ''
            ${pkgs.zulu8}/bin/java \
              -Xms8G -Xmx10G \
              -XX:+UseG1GC \
              -XX:MaxGCPauseMillis=50 \
              -javaagent:authlib-injector.jar=ely.by \
              -jar forge-1.7.10-universal.jar nogui
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
          BACKUP_DIR="${serverDir}/backups"
          mkdir -p "$BACKUP_DIR"

          DATE=$(${pkgs.coreutils}/bin/date +%Y-%m-%d_%H-%M-%S)
          echo "Starting backup of minecraft world..."
          ${pkgs.gnutar}/bin/tar -czf "$BACKUP_DIR/world_$DATE.tar.gz" -C "${serverDir}" world
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
