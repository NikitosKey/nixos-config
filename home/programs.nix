{ config, pkgs, ... }:
{
	imports = [
	  ./programs/fish.nix
		./programs/nixvim.nix
		./programs/git.nix
		./programs/hyprland.nix
    ./programs/hyprlock.nix
		./programs/rofi.nix
    ./programs/kitty.nix
    ./programs/waybar.nix
    ./programs/wlogout.nix
	];
}
