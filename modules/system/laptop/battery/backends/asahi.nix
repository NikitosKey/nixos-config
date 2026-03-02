{ pkgs, config, lib, ... }:
let
  bat-limit = pkgs.writeShellScriptBin "bat-limit" ''
    BAT_PATH="/sys/class/power_supply/macsmc-battery"
    STATE_FILE="/var/lib/bat-limit-mode"

    if [ ! -d "$BAT_PATH" ]; then exit 1; fi
    CAPACITY=$(cat "$BAT_PATH/capacity")

    MODE=''${1:-$(cat $STATE_FILE 2>/dev/null || echo "full")}

    case "$MODE" in
      limit80)
        if [ "$CAPACITY" -gt 80 ]; then
          echo "inhibit-charge" > "$BAT_PATH/charge_behaviour"
          echo 100 > "$BAT_PATH/charge_control_end_threshold"
        else
          echo 80 > "$BAT_PATH/charge_control_end_threshold"
          echo "auto" > "$BAT_PATH/charge_behaviour"
        fi
        ;;
      limit20)
        echo "inhibit-charge" > "$BAT_PATH/charge_behaviour"
        echo 100 > "$BAT_PATH/charge_control_end_threshold"
        ;;
      full)
        echo "auto" > "$BAT_PATH/charge_behaviour"
        echo 100 > "$BAT_PATH/charge_control_end_threshold"
        ;;
    esac

    if [ ! -z "$1" ]; then
      echo "$1" > "$STATE_FILE"
    fi
  '';
  bat-info = pkgs.writeShellScriptBin "bat-info" ''
    export PATH=''${lib.makeBinPath [ pkgs.bc pkgs.coreutils pkgs.gnused ]}:$PATH

    BAT="/sys/class/power_supply/macsmc-battery"
    [ ! -d "$BAT" ] && exit 1

    CAPACITY=$(cat "$BAT/capacity")
    STATUS=$(cat "$BAT/status")
    BEHAVIOUR=$(cat "$BAT/charge_behaviour")
    THRESHOLD=$(cat "$BAT/charge_control_end_threshold")

    POWER_RAW=$(cat "$BAT/power_now")
    WATTS=$(echo "scale=1; $POWER_RAW / 1000000" | ${pkgs.bc}/bin/bc -l)
    [[ $WATTS == .* ]] && WATTS="0$WATTS"

  if [[ "$STATUS" == "Not charging" ]]; then
      ICON="󱟩"
      MODE="Desktop (Bypass)"
  elif [[ "$STATUS" == "Charging" ]]; then
      ICON="󱐋"
      MODE="Charging"
  elif [[ "$STATUS" == "Full" ]]; then
      ICON="󱟠"
      MODE="Full"
  elif [[ "$THRESHOLD" -eq 80 ]] && [[ "$STATUS" == "Not charging" ]]; then
      ICON="󱟢"
      MODE="Healthy (80%)"
  else
      if [ "$CAPACITY" -gt 90 ]; then ICON="󰁹";
      elif [ "$CAPACITY" -gt 70 ]; then ICON="󰂀";
      elif [ "$CAPACITY" -gt 50 ]; then ICON="󰁾";
      elif [ "$CAPACITY" -gt 30 ]; then ICON="󰁼";
      else ICON="󰁺"; fi
      MODE="Standard"
  fi

    HEALTH=$(cat "$BAT/health" 2>/dev/null || echo "Unknown")
    CYCLES=$(cat "$BAT/cycle_count" 2>/dev/null || echo "0")

    CLASS=$(echo "$STATUS" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

    printf '{"text": "%s %d%%", "tooltip": "󱊥 Mode: %s\\n󱐋 Status: %s\\n󰓅 Power: %sW\\n󰚚 Health: %s\\n󱍸 Cycles: %s", "class": "%s"}\n' \
      "$ICON" "$CAPACITY" "$MODE" "$STATUS" "$WATTS" "$HEALTH" "$CYCLES" "$CLASS"
  '';
in {
  config = lib.mkIf (config.myOptions.batteryBackend == "asahi") {
    environment.systemPackages = [
      bat-limit
      bat-info
    ];

    systemd.services.bat-limit-init = {
      description = "Restore Asahi Battery Charge Limit";
      after = [ "multi-user.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${bat-limit}/bin/bat-limit";
        RemainAfterExit = true;
      };
    };

    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.policykit.exec" &&
            action.lookup("program") == "${bat-limit}/bin/bat-limit" &&
            subject.user == "${config.myOptions.username}") {
          return polkit.Result.YES;
        }
      });
    '';

    systemd.tmpfiles.rules = [
      "f /var/lib/bat-limit-mode 0644 root root - full"
    ];
  };
}
