{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.myOptions;
  backend = cfg.batteryBackend;

  # Define the wrapper script
  chargeControlScript = pkgs.writeShellScriptBin "charge-control" ''
    #!/bin/sh
    # Generic wrapper for battery charge control
    # Backend: ${backend}

    if [ "${backend}" = "asahi" ]; then
      # Delegate to Asahi specific script
      # We rely on bat-limit being in the system PATH
      exec bat-limit "$@"
    else
      echo "Error: No valid battery backend configured."
      echo "Current backend: ${backend}"
      exit 1
    fi
  '';
in
{
  imports = [
    ./backends/asahi.nix
  ];

  # Add the script to system packages if a backend is selected
  environment.systemPackages = mkIf (backend != "none") [
    chargeControlScript
  ];

  # Allow executing charge-control without password via pkexec
  security.polkit.extraConfig = mkIf (backend != "none") ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.policykit.exec" &&
          action.lookup("program") == "${chargeControlScript}/bin/charge-control" &&
          subject.user == "${cfg.username}") {
        return polkit.Result.YES;
      }
    });
  '';
}
