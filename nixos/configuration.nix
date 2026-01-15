# ~/nixos-config/nixos/configuration.nix
{ config, pkgs, lib, self, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
    ./users.nix
    ./power-management.nix
    ./services.nix
		./security.nix
  ];

	nix = {
		settings = {
			cores = 10;
			experimental-features = [ "nix-command" "flakes" ];
			auto-optimise-store = true;
      extra-platforms = config.boot.binfmt.emulatedSystems;
		};
	};

  nixpkgs = {
    hostPlatform = lib.mkDefault "aarch64-linux";
    config = {
      allowUnfree = true;
      allowUnsupportedSystem = true;
    };
  };

	programs.nix-ld.enable = true;

  i18n.defaultLocale = "ru_RU.UTF-8";
  console = {
    earlySetup = false;
    font = "ter-u32n";
    packages = with pkgs; [ terminus_font ];
    keyMap = "ru";
  };

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="graphics", KERNEL=="fb*", RUN+="${pkgs.systemd}/bin/systemctl restart systemd-vconsole-setup"
    ACTION=="add", SUBSYSTEM=="drm", KERNEL=="card*", RUN+="${pkgs.systemd}/bin/systemctl restart systemd-vconsole-setup"
  '';

  time.timeZone = "Europe/Moscow"; 
  system.stateVersion = "25.11"; 
}
