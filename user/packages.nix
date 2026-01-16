# ~/nixos-config/home-manager/packages.nix
{ inputs, pkgs, ... }:
let
  pkgs-x86 = import inputs.nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
in
{ 
  home.packages = with pkgs; ([
    # Утилиты
    unstable.fastfetch
    unstable.grc
    unstable.ncdu
    unstable.btop
		unstable.ripgrep
		grimblast
    swappy
    grim
    tmux
    unstable.tree
    unstable.yazi
    zip
    unzip
    gnutar
    gzip
    pavucontrol
    networkmanagerapplet 
    blueman         
    swaynotificationcenter
    unstable.gnome-calendar
		# Разработка
    unstable.lazygit
		unstable.lazydocker
    # Приложения
    unstable.firefox
    unstable.telegram-desktop
    unstable.obs-studio
    unstable.nautilus
		unstable.yandex-music
    unstable.obsidian
		dorion
		unstable.libreoffice
    unstable.mpv
    unstable.gimp
    unstable.krita
    unstable.inkscape
    unstable.prismlauncher
    unstable.reaper
    # Шрифты
    nerd-fonts.hack
		nerd-fonts.jetbrains-mono
		# Буффер обмена
    wl-clipboard
    cliphist
		wtype
		# Темы
	  libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    kdePackages.qt6ct
		kdePackages.qtstyleplugin-kvantum
  ]) ++ [ 
];
}
