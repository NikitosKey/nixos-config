# ~/nixos-config/home-manager/home.nix
{ self, config, inputs, pkgs, nixpkgs, ... }:
{
  imports = [
    ./packages.nix
		./programs.nix
		./services.nix
    ./theming.nix
  ];

  # Основные настройки пользователя
  home.username = "nikitoskey";
  home.homeDirectory = "/home/nikitoskey";

	home.sessionVariables = {
		NIXOS_OZONE_WL = "1"; 
		GDK_BACKEND = "wayland,x11";
	  EDITOR = "nvim";
		HYPRCURSOR_THEME = "McMojave";
    GRIMBLAST_EDITOR = "swappy";
	};

  fonts.fontconfig.enable = true;

  home.stateVersion = "25.11";
}
