{ pkgs, config, lib, ... }: 
{
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

  users.users.greeter = {
    extraGroups = [ "video" "render" "input" "tty" ];
  };
}
