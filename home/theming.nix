{ config, inputs, pkgs, lib, ... }:

{
  stylix = {
      enable = true;
      autoEnable = true;

      base16Scheme = pkgs.lib.mkForce "${pkgs.base16-schemes}/share/themes/onedark-dark.yaml";
      image = ../assets/wallpapers/nix-glow-black.png; 

      polarity = "dark";

      opacity = {
        applications = 0.9;
        terminal = 0.8;
        desktop = 0.9;
        popups = 0.9;
      };

      cursor = {
        package = pkgs.apple-cursor;
        name = "macOS";
        size = 32;
      };

     icons = {
        enable = true;
        package = pkgs.papirus-icon-theme;
        dark = "Papirus-Dark";
        light = "Papirus-Light";
      };

      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.zed-mono;
          name = "ZedMono Nerd Font";
        };
        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Sans";
        };
        serif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };
        
        sizes = {
          applications = 12;
          terminal = 14;
          desktop = 10;
          popups = 10;
        };
      };
  };
}
