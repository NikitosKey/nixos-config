# ~/nixos-config/home-manager/desktop/waybar/waybar.nix
{ pkgs, config, ... }: {
  programs.waybar = {
    enable = true;
    style = ''
      * {
          min-height: 0; border-radius: 20px; /* Скругление */
          font-weight: 600;
      }
      /* Делаем панель прозрачной или полупрозрачной */
      window#waybar {
        background-color: rgba(0,0,0,0); 
      }

      /* Общий стиль для модулей-островков */
      .modules-left, .modules-right {
        background-color: transparent; /* Цвет из темы Stylix */
        border: 1px solid @base0D; /* Акцентная рамка */
        padding: 2px 6px;
        margin-top: 0px; /* Отступ сверху */
        margin-left: 4px;
        margin-right: 4px;
      }

      #custom-dashboard {
        background-color: @base0D;
        color: @base00;
        padding: 0 8px;
        margin-top: 2px;
        margin-left: 2px;
        margin-right: 2px;
      }
      
      #pulseaudio, #network, #bluetooth, #custom-battery, #clock, #custom-notification, #tray{
        padding: 0 8px;
        background-color: transparent;
        margin: 0 2px;
      }

      #workspaces {
          background: transparent; 
          margin: 2px 4px;
          padding: 0;
      }

      #workspaces button {
          padding: 0 8px;
          margin: 0 2px;
          border-radius: 6px;
          color: @base05;
          background: transparent;
          
          border: none;
          box-shadow: none;
          text-shadow: none;
          transition: all 0.2s ease;
      }

      #workspaces button:hover {
          background-color: @base02;
          color: @base05;
      }

      #workspaces button.active {
          color: @base00;
          background-color: @base0D;
          
          border: none; 
          border-bottom: none;
          box-shadow: none;
          
          /* padding: 0 10px; */
      }
      
      #workspaces button.urgent {
          background-color: @base08;
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
        height = 30;
        spacing = 0;
        
        modules-left = [ "custom/dashboard" "hyprland/workspaces" ];
        modules-center = [ ];
        modules-right = [ "tray" "pulseaudio" "custom/battery" "clock" "custom/notification" ];

        "custom/dashboard" = {
          format = " ";
          on-click = "rofi-power";
          tooltip = false;
        };

        "hyprland/workspaces" = {
          on-click = "activate";
        };

        "pulseaudio" = {
          format = "{icon}";
          format-muted = "";
          format-icons = {
            default = ["" "" ""];
          };
          on-click-right = "wpctl set-mute @DEFAULT_SINK@ toggle";
          on-click = "pavucontrol";
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

        "clock" = {
          format = "{:%H:%M}";
          tooltip-format = "<tt>{calendar}</tt>";
          on-click = "gnome-calendar";
        };
        
        "tray" = {
          spacing = 8;
        };

        "custom/notification" = {
          tooltip = true;
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

        "custom/battery" = {
          exec = "bat-info";
          interval = 2;
          return-type = "json";
          format = "{}";
          on-click = "rofi-battery";
          tooltip = true;
        };
      };
    };
  };
}

