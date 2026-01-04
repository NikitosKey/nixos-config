{ inputs, pkgs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
  anyrunPkgs = inputs.anyrun.packages.${system};
in
{
  programs.anyrun = {
    enable = true;
    config = {
      plugins = [
        anyrunPkgs.applications
        anyrunPkgs.shell
        anyrunPkgs.rink
        anyrunPkgs.stdin
      ];

      x.fraction = 0.5;
      y.fraction = 0.2;
      width.fraction = 0.25;
      hideIcons = false;
      ignoreExclusiveZones = true;
      layer = "overlay";
      hidePluginInfo = true;
      closeOnClick = true;
      showResultsImmediately = true;
      maxEntries = 5;
    };

    extraCss = ''
      window {
        background: transparent;
      }

      box.main {
        background: #161616;
        border: 1px solid #5599d2;
        border-radius: 12px;
        padding: 8px;
      }

      text {
        background: rgba(255, 255, 255, 0.05);
        border-radius: 8px;
        padding: 4px 8px;
        color: #eeeeee;
      }

      /* Вместо display: none используем обнуление размеров */
      label.match.description {
        font-size: 0px;
        color: transparent;
      }

      #match.selected {
        background: #5599d2;
        color: #161616;
        border-radius: 8px;
      }

      /* Делаем иконки меньше, чтобы не было громоздко */
      image.match {
        min-width: 24px;
        min-height: 24px;
      }
    '';

    extraConfigFiles."applications.ron".text = ''
      Config(
        desktop_actions: false,
        max_entries: 5,
        // Исправленный формат терминала и пути для NixOS
        terminal: Some(Terminal(command: "kitty")),
        desktop_dirs: [
          "/run/current-system/sw/share/applications",
          "/home/nikitoskey/.nix-profile/share/applications"
        ],
      )
    '';
  };
}
