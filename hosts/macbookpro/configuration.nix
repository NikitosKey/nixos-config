# hosts/macbookpro/configuration.nix
{ config, pkgs, lib, self, inputs, ... }:
{
  imports = [
    ./hardware.nix
  ];

  myOptions = {
    isLaptop = true;
    isDesktop = true;
    batteryBackend = "asahi";
  };

	nix = {
		settings = {
      extra-platforms = config.boot.binfmt.emulatedSystems;
    };
	};

  nixpkgs = {
    hostPlatform = lib.mkForce "aarch64-linux";
  };

  users.users.nikitoskey.extraGroups = [ "audio" "pipewire" "kvm" "fuse" "video" "render" ];

	programs.nix-ld.enable = true;

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="graphics", KERNEL=="fb*", RUN+="${pkgs.systemd}/bin/systemctl restart systemd-vconsole-setup"
    ACTION=="add", SUBSYSTEM=="drm", KERNEL=="card*", RUN+="${pkgs.systemd}/bin/systemctl restart systemd-vconsole-setup"
  '';

  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; ([
    brightnessctl
		playerctl
    networkmanager-openconnect
    distrobox
    dive
    podman-tui
  ] ++ []);

  system.stateVersion = "25.11";
}
