{ pkgs, config, lib, ... }: 
{
  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     default_session = {
  #       command = "${pkgs.tuigreet}/bin/tuigreet --time --asterisks --remember --cmd Hyprland";
  #       user = "greeter";
  #     };
  #   };
  # };
  # programs.regreet.enable = true;
  #
  # environment.systemPackages = [ pkgs.cage ];
  #
  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     default_session = {
  #       command = "${pkgs.dbus}/bin/dbus-run-session ${pkgs.cage}/bin/cage -s -- ${pkgs.regreet}/bin/regreet";
  #       user = "greeter";
  #     };
  #   };
  # };

  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "Hyprland";
        user = "nikitoskey";
      };
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --cmd Hyprland";
        user = "greeter";
      };
    };
  };
}
