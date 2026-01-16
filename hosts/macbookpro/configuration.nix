# hosts/macbookpro/configuration.nix
{ config, pkgs, lib, self, inputs, ... }:

{
  imports = [
    ./hardware.nix
    ./packages.nix
    ./users.nix
    ./power-management.nix
    ./services.nix
		./security.nix
  ];

	nix = {
		settings = {
			cores = 10;
      extra-platforms = config.boot.binfmt.emulatedSystems;
	    extra-substituters = [ "https://apple-silicon.cachix.org" ];
      extra-trusted-public-keys = [ "apple-silicon.cachix.org-1:99u96Qer9uL2vQYvL8m48YjY86YI49a8B8v6YF9Xm7Q=" ];	
    };
	};

  nixpkgs = {
    hostPlatform = lib.mkForce "aarch64-linux";
    config = {
      allowUnfree = true;
      allowUnsupportedSystem = true;
    };
  };

  users.users.nikitoskey.extraGroups = [ "audio" "pipewire" "kvm" "fuse" "video" "render" ];

	programs.nix-ld.enable = true;

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="graphics", KERNEL=="fb*", RUN+="${pkgs.systemd}/bin/systemctl restart systemd-vconsole-setup"
    ACTION=="add", SUBSYSTEM=="drm", KERNEL=="card*", RUN+="${pkgs.systemd}/bin/systemctl restart systemd-vconsole-setup"
  '';

  security.rtkit.enable = true;


  environment.systemPackages = with pkgs; [
    brightnessctl 
		playerctl
    networkmanager-openconnect
    distrobox
    dive
    podman-tui
  ];
  system.stateVersion = "25.11"; 
}
