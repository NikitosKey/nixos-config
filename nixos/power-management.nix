# ~/nixos-config/nixos/power-management.nix
{ config, pkgs, ... }: 
{
  
  powerManagement.enable = true;
  services.power-profiles-daemon.enable = true;

  services.logind.settings = {
    Login = {
      HandleLidSwitch = "suspend";
      HandlePowerKey = "poweroff";
      HandlePowerKeyLongPress = "poweroff";
    };
  };

  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    SuspendState=freeze 
    SuspendMode=s2idle
  '';
}
