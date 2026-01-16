# ~/nixos-config/nixos/power-management.nix
{ lib, ... }: 
{
  powerManagement.enable = true;
  services.power-profiles-daemon.enable = lib.mkDefault true;

  services.logind.settings = {
    Login = {
      HandleLidSwitch  = lib.mkDefault "suspend";
      HandlePowerKey = lib.mkDefault "suspend";
      HandlePowerKeyLongPress = "poweroff";
    };
  };

  systemd.sleep.extraConfig = lib.mkDefault ''
    AllowSuspend=yes
  '';
}
