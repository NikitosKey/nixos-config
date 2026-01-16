# system/desktop/fonts.nix
{ pkgs, ... }: {
  fonts = {
    packages = with pkgs; [
      liberation_ttf
      libertine
      tempora_lgc
      
      cm_unicode
      lmmath
      stix-two
      gentium
      
      noto-fonts
      noto-fonts-emoji

      corefonts
    ];

    fontconfig.defaultFonts = {
      serif = [ "Linux Libertine G" "Liberation Serif" "Times New Roman" ];
      sansSerif = [ "Liberation Sans" "Arial" ];
      monospace = [ "ZedMono Nerd Font" "JetBrainsMono Nerd Font" ];
    };
  };
}
