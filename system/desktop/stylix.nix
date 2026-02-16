# system/desktop/stylix.nix
{ config, inputs, pkgs, lib, ... }:
let
  wallpaper = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/gytis-ivaskevicius/high-quality-nix-content/master/wallpapers/nix-glow-black.png";
    sha256 = "sha256-3AG1n3BrjR/iJVqiSZbj/ZeAZG+SB1zpGsTmY/SDFMk=";
  };
in
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix = {
      enable = true;
      autoEnable = true;

      base16Scheme = pkgs.lib.mkForce "${pkgs.base16-schemes}/share/themes/onedark-dark.yaml";
      image = wallpaper;

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
