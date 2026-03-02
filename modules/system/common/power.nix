{ lib, ... }:

{
  # Enable general power management infrastructure
  powerManagement.enable = lib.mkDefault true;

  services.logind.settings = {
    Login = {
      # Safety feature: Long press power button to power off
      HandlePowerKeyLongPress = "poweroff";
    };
  };

  # Ensure suspension is enabled at the systemd level
  systemd.sleep.extraConfig = lib.mkDefault ''
    AllowSuspend=yes
  '';
}
