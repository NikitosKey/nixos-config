# ~/nixos-config/home-manager/packages.nix
{ inputs, pkgs, ... }:

{ home.packages = with pkgs; [
    # Терминал
    ueberzugpp
    # Утилиты
    fastfetch
    grc
    ncdu
    htop
    btop
		ripgrep
		grimblast
    swappy
    grim
    slurp
    tmux
    tree
    yazi
    zip
    unzip
    gnutar
    gzip
		# Разработка
    lazygit
		docker
    podman
		lazydocker
    # Приложения
    imv
    firefox
    v2rayn
    telegram-desktop
    obs-studio
    nautilus
		yandex-music
    obsidian
		dorion
		libreoffice
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
		adwaita-icon-theme
    hicolor-icon-theme
  ];
}
