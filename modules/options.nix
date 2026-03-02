# modules/options.nix
{ lib, ... }:

with lib;
{
  options.myOptions = {
    username = mkOption {
      type = types.str;
      default = "nikitoskey";
      description = "Main username";
    };
    email = mkOption {
      type = types.str;
      default = "nikitwww@gmail.com";
    };
    isLaptop = mkOption {
      type = types.bool;
      default = false;
      description = "Enables laptop features";
    };
    isDesktop = mkOption {
      type = types.bool;
      default = false;
      description = "Enables desktop features";
    };
    isServer = mkOption {
      type = types.bool;
      default = false;
      description = "Enables server features";
    };
    masterKeyPath = mkOption {
      type = types.path;
      default = /var/lib/sops-nix/key.txt;
      description = "Master key path for SOPS";
    };

    batteryBackend = mkOption {
      type = types.enum [ "none" "asahi" ];
      default = "none";
      description = "Battery management backend to use";
    };
  };
}
