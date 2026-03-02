{ lib, ... }:
{
  # Enable power profiles daemon for better battery life management
  services.power-profiles-daemon.enable = lib.mkDefault true;

  # Enable general power management features
  powerManagement.enable = true;

  services.logind.settings = {
    Login = {
      # Suspend when lid is closed
      HandleLidSwitch = lib.mkDefault "suspend";

      # On laptops, power button usually suspends
      HandlePowerKey = lib.mkDefault "suspend";
    };
  };
}
