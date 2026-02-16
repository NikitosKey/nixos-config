# ~/nixos-config/user/packages.nix
{ pkgs, ... }:
{ 
  home.packages = with pkgs; [
    # Utils
		grimblast
    swappy
    grim
    wl-clipboard
    cliphist
		wtype
		# Theming
	  libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    kdePackages.qt6ct
		kdePackages.qtstyleplugin-kvantum
    # Desktop
    pavucontrol
    networkmanagerapplet 
    blueman         
    swaynotificationcenter
    unstable.gnome-calendar
    unstable.nautilus
    # Apps
    unstable.bitwarden-desktop
    unstable.thunderbird
    unstable.telegram-desktop
    unstable.obs-studio
		unstable.yandex-music
    unstable.obsidian
		stable.dorion
		unstable.libreoffice
    unstable.gimp
    # unstable.krita
    unstable.inkscape
    unstable.prismlauncher
    unstable.reaper
  ];
}
