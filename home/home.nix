# ~/nixos-config/home-manager/home.nix
{ self, config, inputs, pkgs, ... }:
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
  # Заставляет Electron/Chromium приложения работать нативно в Wayland
		NIXOS_OZONE_WL = "1"; 
		GDK_BACKEND = "wayland,x11";
	  MOZ_ENABLE_WAYLAND = "1"; # Для Firefox (на всякий случай, хотя он обычно сам знает)
	  EDITOR = "nvim";
		HYPRCURSOR_THEME = "McMojave";
    GRIMBLAST_EDITOR = "swappy";
	};

  fonts.fontconfig.enable = true;

  home.stateVersion = "25.11";
}
