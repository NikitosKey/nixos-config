# ~/nixos-config/home-manager/desktop/hyprland/hyprland.nix { inputs, pkgs, ... }:
{
  wayland.windowManager.hyprland  = {
    enable = true; systemd.enable = true; settings = {
      # This is an example Hyprland config file for Nix.
      # Refer to the wiki for more information.
      # https://wiki.hypr.land/Configuring/
      # https://wiki.hypr.land/Nix/
      # https://wiki.hypr.land/Nix/Hyprland-on-NixOS/
      # https://wiki.hypr.land/Nix/Hyprland-on-Home-Manager/

      # Please note not all available settings / options are set here.
      # For a full list, see the wiki

      # You can split this configuration into multiple files
      # Create your files separately and then link them to this file like this:
      # source = ~/.config/hypr/myColors.conf
      # todo: make the line above nix-ish


      ################
      ### MONITORS ###
      ################

      # See https://wiki.hypr.land/Configuring/Monitors/
      monitor = "eDP-1,3456x2234@60,0x0,2";


      ###################
      ### MY PROGRAMS ###
      ###################

      # See https://wiki.hypr.land/Configuring/Keywords/

      # Set programs that you use

      "$terminal" = "alacritty";
      "$fileManager" = "nautilus";
      "$menu" = "rofi -show";


      #################
      ### AUTAUTOSTARTOSTART ###
      #################

      # Autostart necessary processes (like notifications daemons, status bars, etc.)
      # Or execute your favorite apps at launch like this:

      "exec-once" = [
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "v2rayN"
        # "waybar" & hyprpaper & firefox"
      ];


      #############################
      ### ENVIRONMENT VARIABLES ###
      #############################

      # See https://wiki.hypr.land/Configuring/Environment-variables/

      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];


      ###################
      ### PERMISSIONS ###
      ###################

      # See https://wiki.hypr.land/Configuring/Permissions/
      # Please note permission changes here require a Hyprland restart and are not applied on-the-fly
      # for security reasons

      # ecosystem = {
      #   enforce_permissions = 1;
      # };

      # permission = [
      #   "/usr/(bin|local/bin)/grim, screencopy, allow"
      #   "/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland, screencopy, allow"
      #   "/usr/(bin|local/bin)/hyprpm, plugin, allow"
      # ];


      #####################
      ### LOOK AND FEEL ###
      #####################

      # Refer to https://wiki.hypr.land/Configuring/Variables/

      # https://wiki.hypr.land/Configuring/Variables/#general
      general = {
        gaps_in = 2;
        gaps_out = 4;

        border_size = 1;

        "col.active_border" = "rgba(7aa2f7ee) rgba(bb9af7ee) 45deg";
        "col.inactive_border" = "rgba(565f89aa)";

        # Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = true;
        extend_border_grab_area = 20;

        # Please see https://wiki.hypr.land/Configuring/Tearing/ before you turn this on
        allow_tearing = true;

        layout = "dwindle";
      };

      # https://wiki.hypr.land/Configuring/Variables/#decoration
      decoration = {
        rounding = 10;
        rounding_power = 2;

        # Change transparency of focused and unfocused windows
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };

        # https://wiki.hypr.land/Configuring/Variables/#blur
        blur = {
          enabled = true;
          size = 3;
          passes = 1;

          vibrancy = 0.1696;
        };
      };

      # https://wiki.hypr.land/Configuring/Variables/#animations
      animations = {
        enabled = "yes, please :)";

        # Default animations, see https://wiki.hypr.land/Configuring/Animations/ for more

        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];

        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
          "zoomFactor, 1, 7, quick"
        ];
      };

      # Ref https://wiki.hypr.land/Configuring/Workspace-Rules/
      # "Smart gaps" / "No gaps when only"
      # uncomment all if you wish to use that.
      # workspace = [
      #   "w[tv1], gapsout:0, gapsin:0"
      #   "f[1], gapsout:0, gapsin:0"
      # ];
      # windowrule = [
      #   "bordersize 0, floating:0, onworkspace:w[tv1]"
      #   "rounding 0, floating:0, onworkspace:w[tv1]"
      #   "bordersize 0, floating:0, onworkspace:f[1]"
      #   "rounding 0, floating:0, onworkspace:f[1]"
      # ];

      # See https://wiki.hypr.land/Configuring/Dwindle-Layout/ for more
      dwindle = {
        pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # You probably want this
      };

      # See https://wiki.hypr.land/Configuring/Master-Layout/ for more
      master = {
        new_status = "master";
      };

      # https://wiki.hypr.land/Configuring/Variables/#misc
      misc = {
        force_default_wallpaper = 0; # Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = true; # If true disables the random hyprland logo / anime girl background. :(
        focus_on_activate = true;
      };


      #############
      ### INPUT ###
      #############

      # https://wiki.hypr.land/Configuring/Variables/#input

      input = {
        kb_layout = "us,ru";
        kb_variant = "";
        kb_model = "";
        kb_options = "caps:swapcase,grp:ctrl_space_toggle";
        kb_rules = "";

        follow_mouse = 1;

        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

        touchpad = {
          natural_scroll = true;        # Инверсия скролла (как на Mac)
          disable_while_typing = false;
          tap-to-click = false;         # Выключает тап по касанию (нужно будет именно вдавливать)
          clickfinger_behavior = true;  # ВАЖНО: включает режим "1 палец - ЛКМ, 2 пальца - ПКМ"
          scroll_factor = 0.5;          # Опционально: уменьшить скорость скролла (на маках он бывает слишком резким)
        };
      };

      # https://wiki.hypr.land/Configuring/Variables/#gestures
      gestures = {
        workspace_swipe_invert = true;
       # workspace_swipe_distance = 700;
        gesture="3, horizontal, workspace";
      };

      # Example per-device config
      # See https://wiki.hypr.land/Configuring/Keywords/#per-device-input-configs for more
      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };


      ###################
      ### KEYBINDINGS ###
      ###################

      # See https://wiki.hypr.land/Configuring/Keywords/
      "$mainMod" = "SUPER"; # Sets "Windows" key as main modifier
      "$pip" = "title:Picture-in-Picture";

      bind = [
        # Example binds, see https://wiki.hypr.land/Configuring/Binds/ for more
        "$mainMod, T, exec, $terminal"
        "$mainMod, Q, killactive,"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, F, togglefloating,"
        "$mainMod, SPACE, exec, $menu"
        "$mainMod, P, pseudo," # dwindle
        "$mainMod, S, togglesplit," # dwindle 
        "$mainMod SHIFT, V, exec, rofi-clipboard"

        # Move focus with mainMod + arrow keys
        "$mainMod, H, movefocus, l"
        "$mainMod, L, movefocus, r"
        "$mainMod, K, movefocus, u"
        "$mainMod, J, movefocus, d"

        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
# Example special workspace (scratchpad)
        "$mainMod, M, togglespecialworkspace, magic"
        "$mainMod SHIFT, M, movetoworkspace, special:magic"

        # Scroll through existing workspaces with mainMod + scroll
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        # Выбор области и копирование в буфер обмена
        "$mainMod SHIFT, S, exec, grimblast --freeze save area - | swappy -f -"

        "$mainMod, C, exec, hyprctl dispatch sendshortcut CTRL, C, activewindow"
        "$mainMod, V, exec, hyprctl dispatch sendshortcut CTRL, V, activewindow"
        "$mainMod, X, exec, hyprctl dispatch sendshortcut CTRL, X, activewindow"
        "$mainMod, Z, exec, hyprctl dispatch sendshortcut CTRL, Z, activewindow"
        "$mainMod, A, exec, hyprctl dispatch sendshortcut CTRL, A, activewindow"
        "$mainMod, S, exec, hyprctl dispatch sendshortcut CTRL, S, activewindow"
      ];

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      # Laptop multimedia keys for volume and LCD brightness
      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];

      # Requires playerctl
      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      ##############################
      ### WINDOWS AND WORKSPACES ###
      ##############################

      # See https://wiki.hypr.land/Configuring/Window-Rules/ for more
      # See https://wiki.hypr.land/Configuring/Workspace-Rules/ for workspace rules
      layerrule =[
        "blur,alacritty"
        "animation slide top, rofi"
      ];

        windowrulev2 = [
        # Example windowrule
        # "float,class:^(kitty)$,title:^(kitty)$"
        "workspace 10 silent, class:^(v2rayN)$"
        "float,class:(org.pulseaudio.pavucontrol)"
        "size 1200 600,class:(org.pulseaudio.pavucontrol)"
        "float,class:(.blueman-manager-wrapped)"
        "size 200 400,class:(.blueman-manager-wrapped)"
       

        "float,$pip"
        "pin,$pip"
        "opacity 1.0,$pip"
        "size 355 200,$pip"
        "move 100%-w-40 100%-w-40,$pip"


        # Ignore maximize requests from apps. You'll probably like this.
        "suppressevent maximize, class:.*"

        # Fix some dragging issues with XWayland
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"


        "float, class:^(ueberzugpp.*)$"
        "noborder, class:^(ueberzugpp.*)$"
        "noshadow, class:^(ueberzugpp.*)$"
        
        # 2. Анимация: ВЫКЛЮЧИТЬ ПОЛНОСТЬЮ.
        # Любое движение создает шлейфы и артефакты при тайлинге
        "noanim, class:^(ueberzugpp.*)$"
        
        # 3. Фокус: запретить перехват ввода
        "noinitialfocus, class:^(ueberzugpp.*)$"
        
        # 4. Внешний вид: запретить блюр САМОЙ КАРТИНКИ
        # (иначе Hyprland размоет превью, превратив его в кашу или белый квадрат)
        "noblur, class:^(ueberzugpp.*)$"
        
        # 5. Поведение: Игнорировать запросы на полный экран/максимизацию
        # Это лечит баги, когда картинка пытается занять весь экран при ресайзе
        "suppressevent maximize, class:^(ueberzugpp.*)$"
        "suppressevent fullscreen, class:^(ueberzugpp.*)$"

      ];
    };
  };
  xdg.configFile."swappy/config".text = ''
    [Default]
    save_dir=$HOME/Pictures/Screenshots
    save_filename_format=swappy-%Y%m%d-%H%M%S.png
    show_panel=false
    line_size=5
    text_size=20
    text_font=sans-serif
    paint_mode=brush
    early_exit=true
    fill_shape=false
  '';
}
