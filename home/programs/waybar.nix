# ~/nixos-config/home-manager/desktop/waybar/waybar.nix
{ pkgs, config, ... }: {
  programs.waybar = {
    enable = true;
    style = ''
      * {
          font-size: 13px; 
          min-height: 0;
          border-radius: 20px; /* Скругление */
          font-weight: 600;
      }
      /* Делаем панель прозрачной или полупрозрачной */
      window#waybar {
        background-color: rgba(0,0,0,0); 
      }

      /* Общий стиль для модулей-островков */
      .modules-left, .modules-right {
        background-color: @base00; /* Цвет из темы Stylix */
        border: 1px solid @base0D; /* Акцентная рамка */
        padding: 2px 6px;
        margin-top: 0px; /* Отступ сверху */
        margin-left: 4px;
        margin-right: 4px;
      }

      #custom-dashboard {
        background-color: @base0D; /* Синий цвет из Kanagawa */
        color: @base00; /* Цвет фона темы для контраста */
        padding: 0 8px;
        margin-top: 2px;
        margin-left: 2px;
        margin-right: 2px; /* Слипаем с воркспейсами или оставляем отступ */
      }
      
      /* Кнопки справа */
      #pulseaudio, #network, #bluetooth, #battery, #clock, #custom-notification, #tray{
        padding: 0 8px;
        background-color: transparent;
        margin: 0 2px;
      }

      /* Контейнер воркспейсов (островок) */
      #workspaces {
          background: transparent; 
          /* Или @base00, если хочешь, чтобы весь блок был темным */
          margin: 2px 4px;
          padding: 0;
      }

      /* Кнопка с цифрой (неактивная) */
      #workspaces button {
          padding: 0 8px;       /* Воздух вокруг цифры */
          margin: 0 2px;        /* Расстояние между цифрами */
          border-radius: 6px;   /* Скругление квадратика */
          color: @base05;       /* Цвет текста (серый/белый) */
          background: transparent; /* Прозрачный фон */
          
          /* УБИРАЕМ ВСЕ ГРАНИЦЫ И ТЕНИ */
          border: none;
          box-shadow: none;
          text-shadow: none;
          transition: all 0.2s ease; /* Плавная анимация */
      }

      /* При наведении мышкой */
      #workspaces button:hover {
          background-color: @base02; /* Чуть светлее фон */
          color: @base05;
      }

      /* АКТИВНЫЙ воркспейс (Цифра) */
      #workspaces button.active {
          color: @base00;       /* Текст становится темным (контраст) */
          background-color: @base0D; /* Фон становится акцентным (синим/лиловым из темы) */
          
          /* Гарантированно убираем улыбку/подчеркивание */
          border: none; 
          border-bottom: none;
          box-shadow: none;
          
          /* Если цифра кажется "зажатой", можно чуть увеличить padding тут */
          /* padding: 0 10px; */
      }
      
      /* Если воркспейс срочный (кто-то тегает) */
      #workspaces button.urgent {
          background-color: @base08; /* Красный */
          color: @base00;
      }
      
      #pulseaudio:hover, #network:hover, #bluetooth:hover {
        background-color: @base02;
        border-radius: 8px;
      }
    '';

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 24;
        spacing = 0;
        
        modules-left = [ "custom/dashboard" "hyprland/workspaces" ];
        modules-center = [ ];
        modules-right = [ "tray" "group/hardware" "clock" "custom/notification" ];

        "custom/dashboard" = {
          format = " ";
          on-click = "rofi-power";
          tooltip = false;
        };

        "hyprland/workspaces" = {
          on-click = "activate";
        };

        "group/hardware" = {
          orientation = "horizontal";
          modules = [ "pulseaudio" "battery" ];
        };

        "pulseaudio" = {
          format = "{icon}";
          format-muted = "";
          format-icons = {
            default = ["" "" ""];
          };
          on-click = "wpctl set-mute @DEFAULT_SINK@ toggle";
          on-click-right = "pavucontrol";
          tooltip-format = "{volume}%";
        };

        "network" = {
          format-wifi = "";
          format-ethernet = "󰈀";
          format-disconnected = "";
          tooltip-format = "{essid} ({signalStrength}%)";
          on-click = "nm-connection-editor"; 
        };

        "bluetooth" = {
          format = "";
          format-disabled = "󰂲";
          format-connected = "󰂱";
          on-click = "blueman-manager";
        };

        "battery" = {
          states = { warning = 30; critical = 15; };
          format = "{icon} {capacity}%";
          format-charging = "󰂄";
          format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
        };

        "upower"= {
        #"icon-size": 20,
          hide-if-empty = true;
          tooltip = true;
          tooltip-spacing = 20;
        };

        "clock" = {
          format = "{:%H:%M}";
          tooltip-format = "<tt>{calendar}</tt>";
          actions = {
             on-click-right = "gnome-calendar";
          };
        };
        
        "tray" = {
          spacing = 8;
        };

        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };
      };
    };
  };
}

