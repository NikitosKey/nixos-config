{ config, inputs, pkgs, ... }:
let
  tokyoNightKvantum = pkgs.fetchFromGitHub {
    owner = "colin-heffernan";
    repo = "Kvantum-Tokyo-Night-Theme"; 
    rev = "main";
    hash = "sha256-jCmdCUhyCP1FbPD8RoBv5sV8J+FFet2z771PW6h/yi8=";
  };
in
{
  home.packages = [ inputs.mcmojave-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default ];
	gtk = {
    enable = true;
    theme = {
      package = pkgs.tokyonight-gtk-theme;
      name = "Tokyonight-Dark";
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
#		cursorTheme = {
 #     name = "McMojave-cursors";
 #     package = pkgs.mcmojave-cursors;
 #   };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
  
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
	  # 3. Включаем Qt и говорим использовать qtct
#   qt = {
#     enable = true;
#     platformTheme.name = "qtct";
#     style.name = "kvantum";
#   };
#
#   xdg.configFile."qt5ct/qt5ct.conf".text = ''
# 		[Appearance]
#     custom_palette=true
#     color_scheme_path=${config.xdg.configHome}/qt6ct/style-colors.conf
#     standard_dialogs=xdgdesktopportal
#     style=kvantum
#     icon_theme=Papirus-Dark
#
#     [Fonts]
#     fixed="JetBrainsMono Nerd Font,11,-1,5,50,0,0,0,0,0"
#     general="JetBrainsMono Nerd Font,11,-1,5,50,0,0,0,0,0"
#   '';
#
#   xdg.configFile."qt6ct/qt6ct.conf".text = ''
#     [Appearance]
#     custom_palette=true
#     color_scheme_path=${config.xdg.configHome}/qt6ct/style-colors.conf
#     standard_dialogs=xdgdesktopportal
#     style=kvantum
#     icon_theme=Papirus-Dark
#
#     [Fonts]
#     fixed="JetBrainsMono Nerd Font,11,-1,5,50,0,0,0,0,0"
#     general="JetBrainsMono Nerd Font,11,-1,5,50,0,0,0,0,0"
#   '';
#
#   xdg.configFile."Kvantum/KvArcTokyoNight".source = tokyoNightKvantum;
#
#   xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
#     [General]
#     theme=KvArcTokyoNight
#   '';
}
