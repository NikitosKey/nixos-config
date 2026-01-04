# ~/nixos-config/nixos/configuration.nix
{ config, pkgs, lib, self, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
    ./users.nix
    ./power-management.nix
    ./services.nix
		./security.nix
		./environment.nix
  ];

	nix = {
		settings = {
			cores = 10;
			experimental-features = [ "nix-command" "flakes" ];
			auto-optimise-store = true;
      extra-platforms = config.boot.binfmt.emulatedSystems;
		};
	};

	networking.firewall.checkReversePath = false;
	networking.firewall.allowedUDPPorts = [ 53 ];
	networking.firewall.allowedTCPPorts = [ 53 ];

  nixpkgs.config = {
    allowUnfree = true;
    allowUnsupportedSystem = true;
  };

	programs.nix-ld.enable = true;
  i18n.defaultLocale = "ru_RU.UTF-8";
  console = {
    earlySetup = true;
    font = "ter-v32n";
    packages = with pkgs; [ terminus_font ];
    keyMap = "ru";
  };

  time.timeZone = "Europe/Moscow"; 
  system.stateVersion = "25.11"; 
}
