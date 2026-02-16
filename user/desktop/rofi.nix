{ config, pkgs, ... }:

let
  cliphist = "${pkgs.cliphist}/bin/cliphist";
  rofi = "${pkgs.rofi}/bin/rofi";
  wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";
	wtype = "${pkgs.wtype}/bin/wtype";

  rofi-style = ''
    element { padding: 10px 15px; spacing: 20px; }
    element-icon { size: 32px; vertical-align: 0.5; }
    element-text { vertical-align: 0.5; }
    listview { lines: 6; fixed-height: false; }
    window { width: 400px; border-radius: 12px; }
  '';


    rofi-battery = pkgs.writeShellScriptBin "rofi-battery" ''
      #!/usr/bin/env bash
      full="Full Charge\0icon\x1fbattery-100"
      limit="Limit 80%\0icon\x1fbattery-080"
      stop="AC mode\0icon\x1fac-adapter"

      options="$full\n$limit\n$stop"

      selected=$(echo -e "$options" | ${rofi} -dmenu -i -p "󱐋 Battery" -show-icons \
        -theme-str '${rofi-style}')

      case "$selected" in
          *"Full Charge"*)  pkexec bat-limit full ;;
          *"Limit 80%"*)    pkexec bat-limit limit80 ;;
          *"AC mode"*) pkexec bat-limit limit20 ;;
      esac
    '';

    rofi-power = pkgs.writeShellScriptBin "rofi-power" ''
      lock="Lock\0icon\x1fsystem-lock-screen"
      suspend="Suspend\0icon\x1fsystem-suspend"
      logout="Logout\0icon\x1fsystem-log-out"
      reboot="Reboot\0icon\x1fsystem-reboot"
      shutdown="Shutdown\0icon\x1fsystem-shutdown"

      options="$lock\n$suspend\n$logout\n$reboot\n$shutdown"

      selected=$(echo -e "$options" | ${rofi} -dmenu -i -p " Power" -show-icons \
        -theme-str '${rofi-style}')

      case $selected in
        *"Lock"*)     hyprlock ;;
        *"Suspend"*)  systemctl suspend ;;
        *"Logout"*)   loginctl terminate-user $USER ;;
        *"Reboot"*)    systemctl reboot ;;
        *"Shutdown"*) systemctl poweroff ;;
      esac
    '';
    
    rofi-clipboard = pkgs.writeShellScriptBin "rofi-clipboard" ''
      cache_dir="$HOME/.cache/cliphist/thumbs"
      mkdir -p "$cache_dir"

      selection=$(${cliphist} list | head -n 50 | while read -r line; do
          [ -z "$line" ] && continue
          id=$(echo "$line" | cut -f1)
          content=$(echo "$line" | cut -f2-)

          if [[ "$content" == *"[["*"binary"*"data"* ]]; then
              thumb="$cache_dir/$id.png"
              [ ! -f "$thumb" ] && ${cliphist} decode "$id" > "$thumb" 2>/dev/null

              meta=$(echo "$content" | sed -E 's/.*data [0-9]+ KiB ([a-z]+ [0-9]+x[0-9]+).*/\1/' | tr '[:lower:]' '[:upper:]')
              size=$(echo "$content" | sed -E 's/.*data ([0-9]+ KiB).*/\1/')
              
              if [ -f "$thumb" ]; then
                  printf "  󰋩 Снимок (%s) %s %s\0icon\x1f%s\n" "$id" "$meta" "$size" "$thumb"
              else
                  printf "  󰋩 Ошибка (%s)\0icon\x1ftext-x-generic\n" "$id"
              fi
          else
              clean_text=$(echo "$content" | tr -d '\n\r' | sed 's/  */ /g' | cut -c1-100)
              printf "  󰅍 Текст (%s) %s\0icon\x1ftext-x-generic\n" "$id" "$clean_text"
          fi
      done | ${rofi} -dmenu -i -p "󰅌 " -show-icons -markup-rows \
        -theme-str '
          element { padding: 8px 12px; spacing: 15px; }
          element-icon { size: 48px; border-radius: 8px; }
          element-text { vertical-align: 0.5; }
          listview { lines: 6; fixed-height: false; }
        ')

      if [ -n "$selection" ]; then
          id=$(echo "$selection" | sed -E 's/.* \(([0-9]+)\) .*/\1/')
          
          ${cliphist} decode "$id" | ${wl-copy}
          
          sleep 0.1
          ${wtype} -M ctrl v -m ctrl
      fi
    '';


in {
  home.packages = [
    rofi-clipboard
    rofi-power
    rofi-battery
  ];

  programs.rofi = {
    enable = true;
		plugins = [ pkgs.rofi-calc ];
    
    extraConfig = {
      modes = "drun,calc,run,window,ssh,keys,filebrowser,recursivebrowser";
    
			display-combi = " ";
			display-drun = " ";
			display-run = " ";
			display-calc = "󰃬 ";

			calc-command = "echo -n '{result}' | ${pkgs.wl-clipboard}/bin/wl-copy";
      no-show-history = true;

      show-icons = true;
      sort = true;
    };

    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        bg = mkLiteral "#1e1e2e";
        fg = mkLiteral "#cdd6f4";
        accent = mkLiteral "#89b4fa";
        # background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg";
        margin = 0;
        padding = 0;
      };

      "window" = {
        width = mkLiteral "600px";
        #background-color = mkLiteral "@bg";
        border = mkLiteral "2px";
        # border-color = mkLiteral "@accent";
        border-radius = mkLiteral "12px";
      };

      "element" = {
        border-radius = mkLiteral "8px";
        padding = mkLiteral "4px 8px";
      };

      "element selected" = {
        # background-color = mkLiteral "#313244";
        # text-color = mkLiteral "@accent";
      };

      "element-icon" = {
        size = mkLiteral "32px"; # Для приложений
        vertical-align = mkLiteral "0.5";
      };

      "element-text" = {
        vertical-align = mkLiteral "0.5";
      };

      "inputbar" = {
        padding = mkLiteral "12px";
        children = mkLiteral "[prompt, entry]";
      };
    };
  };
}
