# ~/nixos-config/nixos/packages.nix
{ inputs, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    brightnessctl 
		playerctl
    # asahi-nvram
		# asahi-bless
    # asahi-audio
		# alsa-ucm-conf-asahi
		# alsa-utils
		# alsa-ucm-conf
		# asahi-btsync
		# asahi-wifisync
    networkmanager-openconnect
    distrobox
    dive
    podman-tui
    docker-compose
  ];
  programs.hyprland.enable = true;
  programs.fish.enable = true;
}
