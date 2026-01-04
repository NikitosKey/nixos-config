{ pkgs, config, ... }:

let
  # Цвета Catppuccin Mocha для удобства
  mocha = {
    base = "1e1e2e";
    mantle = "181825";
    text = "cdd6f4";
    mauve = "cba6f7";
    blue = "89b4fa";
    overlay0 = "6c7086";
    surface0 = "313244";
  };
in
{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        # Прозрачность (0.0 - 1.0)
        opacity = 0.85;
        # Отступы для красоты
        padding = { x = 15; y = 15; };
        # Заголовок (если используешь декорации)
        dynamic_title = true;
      };
      
      font = {
        normal = { family = "JetBrainsMono Nerd Font"; style = "Regular"; };
        size = 12.0;
      };

      # Цвета Catppuccin Mocha
      colors = {
        primary = {
          background = "#${mocha.base}";
          foreground = "#${mocha.text}";
        };
        normal = {
          black   = "#45475a";
          red     = "#f38ba8";
          green   = "#a6e3a1";
          yellow  = "#f9e2af";
          blue    = "#${mocha.blue}";
          magenta = "#f5c2e7";
          cyan    = "#94e2d5";
          white   = "#bac2de";
        };
        bright = {
          black   = "#585b70";
          red     = "#f38ba8";
          green   = "#a6e3a1";
          yellow  = "#f9e2af";
          blue    = "#${mocha.blue}";
          magenta = "#f5c2e7";
          cyan    = "#94e2d5";
          white   = "#a6adc8";
        };
      };
    };
  };
}
