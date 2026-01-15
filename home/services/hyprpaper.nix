{ config, pkgs, ... }:

let
  wallpaper = ../../assets/wallpapers/wallpaper.png;
in
{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;

      # Используем интерполяцию ${wallpaper}, чтобы Nix подставил полный путь из Store
      preload = [ "${wallpaper}" ];

      # То же самое для установки обоев
      wallpaper = [ ",${wallpaper}" ];
    };
  };
}
