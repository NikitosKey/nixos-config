{
	programs.hyprpanel = {
    enable = true;

		settings = {

      scalingPriority = "hyprland";
      bar = {
        autoHide = "never";
        layouts = {
          "0" = {
            left = [ "dashboard" "workspaces" "windowtitle" ];
            middle = [ ];
            right = [ "media" "systray" "volume" "network" "bluetooth" "battery" "clock" "notifications" ];
          };
          "1" = {
            left = [ "dashboard" "workspaces" "windowtitle" ];
            middle = [ "media" ];
            right = [ "volume" "clock" "notifications" ];
          };
        };

        bar.launcher.autoDetectIcon = false;
        launcher.icon = "";

        workspaces.show_numbered = true;

        media = {
          truncation = false;
          show_label = false;
          show_active_only = true;
        };

        network.label = false;
        bluetooth.label = false;
        notifications.show_total = true;
        clock.format = "%a %b %d  %H:%M";
				clock.show_label = false;
      };

      # --- 3. ПОВЕДЕНИЕ МЕНЮ ---
      menus = {
        transition = "none";
        power = {
          showLabel = true;
          lowBatteryNotification = true;
        };
        clock = {
          time = {
            military = true;
            hideSeconds = false;
						
          };
          weather = {
            enabled = false;
            unit = "metric";
            location = "Saint Petersburg"; # Если включите
          };
        };
        dashboard = {
          directories.enabled = false;
					shortcuts.enabled = false;
        };
      };

      # --- 4. ВАША ТЕМА CATPPUCCIN MOCHA (ПОЛНАЯ СТРУКТУРА) ---
      theme = {
        font = {
          name = "JetBrainsMono Nerd Font";
          size = "8pt";
          weight = 400;
        };

        bar = {
          background = "#11111b";
          enableShadow = false;
          floating = false;
          border.location = "none";

          buttons = {
            style = "default";
            enableBorders = false;
            # hover = "#45475a";

            # Настройки для каждого модуля на панели
            dashboard = { background = "#242438"; icon = "#f9e2af"; border = "#f9e2af"; };
            workspaces = { background = "#242438"; active = "#f5c2e7"; occupied = "#f2cdcd"; available = "#89dceb"; numbered_active_text_color = "#24283b"; numbered_active_underline_color = "#f5c2e7"; };
            windowtitle = { background = "#242438"; text = "#f5c2e7"; };
            media = { background = "#242438"; icon = "#b4befe"; text = "#b4befe"; };
            volume = { background = "#242438"; icon = "#eba0ac"; text = "#eba0ac"; };
            network = { background = "#242438"; icon = "#cba6f7"; text = "#cba6f7"; };
            bluetooth = { background = "#242438"; icon = "#89dceb"; text = "#89dceb"; };
            battery = { background = "#242438"; icon = "#f9e2af"; text = "#f9e2af"; };
            systray = { background = "#242438"; };
            clock = { background = "#242438"; icon = "#f5c2e7"; text = "#f5c2e7"; };
            notifications = { background = "#242438"; icon = "#b4befe"; total = "#b4befe"; };
            power = { background = "#242438"; icon = "#f38ba8"; };
            cava = { background = "#242438"; text = "#94e2d5"; icon = "#94e2d5"; };
            microphone = { background = "#242438"; text = "#a6e3a1"; icon = "#a6e3a1"; };
            # и т.д. для всех остальных модулей
          };

          menus = {
            enableShadow = true;
            monochrome = false;
            background = "#11111b";
            cards = "#1e1e2e";
            text = "#cdd6f4";
            dimtext = "#585b70";
            border.color = "#313244";
            
            # Структура для каждого отдельного меню
            menu = {
              clock = {
                background.color = "#11111b";
                card.color = "#1e1e2e";
                border.color = "#313244";
                text = "#cdd6f4";
                time = { time = "#f5c2e7"; timeperiod = "#94e2d5"; };
                calendar = { yearmonth = "#94e2d5"; weekdays = "#f5c2e7"; paginator = "#f5c2e6"; currentday = "#f5c2e7"; days = "#cdd6f4"; contextdays = "#585b70"; };
              };
              notifications = {
                background = "#11111b";
                card = "#1e1e2e";
                border = "#313244";
                label = "#b4befe";
                no_notifications_label = "#313244";
                clear = "#f38ba8";
                switch_divider = "#45475a";
                switch = { enabled = "#b4befe"; disabled = "#313245"; puck = "#454759"; };
              };
              dashboard = {
                background.color = "#11111b";
                card.color = "#1e1e2e";
                border.color = "#313244";
                profile.name = "#f5c2e7";
                powermenu = { shutdown = "#f38ba8"; restart = "#fab387"; logout = "#a6e3a1"; sleep = "#89dceb"; };
                monitors = {
                  bar_background = "#45475a";
                  cpu = { icon = "#eba0ac"; label = "#eba0ac"; bar = "#eba0ad"; };
                  ram = { icon = "#f9e2af"; label = "#f9e2af"; bar = "#f9e2ae"; };
                  gpu = { icon = "#a6e3a1"; label = "#a6e3a1"; bar = "#a6e3a2"; };
                  disk = { icon = "#f5c2e7"; label = "#f5c2e7"; bar = "#f5c2e8"; };
                };
              };
              # ... и так далее для volume, network, bluetooth, battery, power, media...
            };
          };
        };

        notification = {
          background = "#181826";
          border = "#313243";
          text = "#cdd6f4";
          label = "#b4befe";
          labelicon = "#b4befe";
          time = "#7f849b";
          actions = { background = "#b4befd"; text = "#181825"; };
          close_button = { background = "#f38ba7"; label = "#11111b"; };
        };

        osd = {
          border.color = "#8ff0a4";
          bar_container = "#11111b";
          icon_container = "#b4beff";
          bar_color = "#b4beff";
          bar_empty_color = "#313244";
          bar_overflow_color = "#f38ba7";
          icon = "#11111b";
          label = "#b4beff";
        };
      };
			# --- 5. ФИНАЛЬНЫЙ ШТРИХ: CSS ДЛЯ ЭФФЕКТА "SPLIT-PANEL" ---
			# Этот блок решает проблему с челкой и вылетом меню за экран.
    };
  };
}
