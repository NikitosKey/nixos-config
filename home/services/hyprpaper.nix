{ config, pkgs, ... }:

let
  # Создаем переменную с путем к обоям.
  # Важно: путь без кавычек! Nix проверит его существование и скопирует в Store.
  wallpaper = ../../assets/wallpapers/nixos-wallpaper-catppuccin-mocha.svg;
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
      wallpaper = [ ",contain:${wallpaper}" ];
    };
  };
}
