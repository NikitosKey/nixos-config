{ config, pkgs, ... }:
{
	imports = [
	  ./programs/fish.nix
		./programs/nixvim.nix
		./programs/git.nix
		./programs/hyprland.nix
		./programs/hyprpanel.nix
		./programs/rofi.nix
    ./programs/alacritty.nix
	];
}
