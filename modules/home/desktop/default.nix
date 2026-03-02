{
  imports = [
    ./packages.nix
    ./waybar.nix
    ./rofi.nix
    ./swaync.nix
    ./hyprland.nix
    ./hypridle.nix
    ./hyprpaper.nix
    ./hyprlock.nix
    ./kitty.nix
    ./cliphist.nix
    ./mpv.nix
    ./udiskie.nix
    ./xdg.nix
  ];

  fonts.fontconfig.enable = true;
}
