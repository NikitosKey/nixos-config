# ~/nixos-config/home-manager/desktop/waybar/waybar.nix

{ pkgs, lib, ... }:

let
  # УЛУЧШЕННЫЙ СКРИПТ КОТИКА (с анимацией бега)
  runcatScript = pkgs.writeShellScript "runcat-animated" ''
    #!/usr/bin/env bash
    frames_slow=("🐈" "🐈‍⬛")
    frames_medium=("🐆" "🐅")
    frames_fast=("🐉" "🔥")
    icon_sleep="😴"

    # Вечный цикл для плавной анимации
    while true; do
      load=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)}' | awk '{print int($1)}')

      local frames_current
      local speed=0.5

      if [ "$load" -lt 10 ]; then
        icon=$icon_sleep
        speed=2 # Спит дольше
      elif [ "$load" -lt 30 ]; then
        frames_current=("''${frames_slow[@]}")
        speed=0.5
      elif [ "$load" -lt 60 ]; then
        frames_current=("''${frames_medium[@]}")
        speed=0.3
      else
        frames_current=("''${frames_fast[@]}")
        speed=0.15
      fi

      if [ "$load" -ge 10 ]; then
        counter_file="/tmp/runcat_counter"
        [ ! -f "$counter_file" ] && echo 0 > "$counter_file"
        counter=$(cat "$counter_file")
        icon="''${frames_current[$counter]}"
        counter=$(( (counter + 1) % ''${#frames_current[@]} ))
        echo $counter > "$counter_file"
      fi
      
      echo "{\"text\": \"$icon\", \"tooltip\": \"CPU Load: $load%\"}"
      sleep $speed
    done
  '';

  calendarScript = pkgs.writeShellScript "waybar-calendar-events" ''
    #!/usr/bin/env bash
    # Заголовок для сегодняшнего дня
    tooltip="<big> Сегодня, $(date +"%d %B")</big>\n"
    
    # Получаем события на сегодня с помощью khal и форматируем их
    events=$(khal list --format "<b>{start-time}</b> - {title}" today)
    
    if [ -n "$events" ]; then
      tooltip+="$events"
    else
      tooltip+="<span color='#888'>Нет событий на сегодня</span>"
    fi

    # Выводим JSON, который Waybar сможет прочитать
    echo "{\"text\": \"$(date "+%H:%M")\", \"tooltip\": \"$tooltip\"}"
  '';

in
{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar; 
    
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 44; 
        spacing = 0;
        
        # --- РАСПОЛОЖЕНИЕ ---
        modules-left = [ "hyprland/workspaces" "custom/runcat" ];
        modules-center = [ ]; # <-- ЦЕНТР ТЕПЕРЬ ПУСТОЙ
        modules-right = [ "tray" "group/hardware" "battery" "custom/notification" "clock" ];

        # --- МОДУЛИ ---

        "hyprland/workspaces" = {
          format = "{name}";
          on-click = "activate";
          persistent-workspaces = { "*" = 5; };
        };

        "custom/runcat" = {
          exec = "${runcatScript}"; # <-- Запускаем скрипт с вечным циклом
          return-type = "json";
          format = "{}";
        };

        "tray" = { icon-size = 18; spacing = 10; };

        "group/hardware" = {
            orientation = "horizontal";
            modules = [ "network" "bluetooth" "pulseaudio" ];
        };

        "pulseaudio" = {
          format = "{icon}";
          format-muted = "";
          format-icons = { default = ["" "" ""]; };
          tooltip-format = "Громкость: {volume}%";
          on-click = "gnome-control-center sound"; # <-- ИЗМЕНЕНО
        };

        "network" = {
          format-wifi = "";
          format-ethernet = "";
          format-disconnected = "⚠";
          tooltip-format = "{ifname}: {essid} ({signalStrength}%)";
          on-click = "gnome-control-center wifi"; # <-- ИЗМЕНЕНО
        };

        "bluetooth" = {
          format = "";
          format-disabled = ""; 
          format-connected = "";
          tooltip-format-connected = "Подключено: {device_alias}";
          on-click = "gnome-control-center bluetooth"; # <-- ИЗМЕНЕНО
        };

        "battery" = {
            states = { good = 95; warning = 30; critical = 15; };
            format = "{icon}   {capacity}%";
            format-charging = "   {capacity}%";
            format-icons = ["" "" "" "" ""];
            on-click = "gnome-control-center power"; # <-- ИЗМЕНЕНО
        };

        "custom/notification" = {
          # ... ваш конфиг без изменений ...
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
        };

        # --- ПОЛНОСТЬЮ ПЕРЕРАБОТАННЫЙ МОДУЛЬ ЧАСОВ ---
        "clock" = {
          exec = "${calendarScript}"; # <-- Используем наш скрипт для вывода
          return-type = "json";
          interval = 60; # Обновляем события раз в минуту
          on-click = "gnome-calendar"; # <-- Открываем полноценный календарь
        };
      };
    };

    # --- CSS ---
    style = ''
      /* ... все ваши @define-color ... */
      @define-color bg #1e1e2e;
      @define-color text #cdd6f4;
      /* ... и так далее ... */

      * { /* ... */ }
      window#waybar { /* ... */ }

      #workspaces, #custom-runcat, #tray, #hardware, #battery, #clock, #custom-notification {
        /* ... общие стили для "капсул" ... */
        background: @surface;
        border-radius: 20px;
        margin-top: 4px;
        margin-bottom: 4px;
        padding-left: 15px;
        padding-right: 15px;
      }
      
      /* ... стили для #workspaces, #custom-runcat, #tray ... */

      /* --- ИСПРАВЛЕНИЕ НАЛОЖЕНИЯ --- */
      #custom-notification {
        margin-right: 10px; /* <-- ДОБАВЛЕНО: Создаем отступ справа */
        padding-left: 12px;
        padding-right: 15px;
        color: @blue;
      }
      
      /* ... остальные ваши стили ... */
    '';
  };
}
