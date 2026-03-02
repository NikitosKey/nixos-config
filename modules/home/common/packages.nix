# ~/nixos-config/user/packages.nix
{ pkgs, ... }:
{ 
  home.packages = with pkgs; [
    grc
    zip
    unzip
    gnutar
    gzip
    p7zip
    unstable.fastfetch
    unstable.tree
    unstable.ncdu
    unstable.btop
    unstable.tmux
    unstable.ripgrep
    unstable.lazygit
    unstable.lazydocker
    unstable.trashy
    unstable.sops
  ];
}
