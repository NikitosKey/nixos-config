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
      noto-fonts-color-emoji

      nerd-fonts.jetbrains-mono
      nerd-fonts.hack
      nerd-fonts.fira-code
      nerd-fonts.fira-mono
      nerd-fonts.zed-mono

      corefonts
    ];

    fontconfig.defaultFonts = {
      serif = [ "Linux Libertine G" "Liberation Serif" "Times New Roman" ];
      sansSerif = [ "Liberation Sans" "Arial" ];
      monospace = [ "ZedMono Nerd Font" "JetBrainsMono Nerd Font" ];
    };
  };
}
