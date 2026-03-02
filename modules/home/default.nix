{ osConfig, lib, ... }:
{
  imports = [
    ./common
  ] ++ (lib.optionals osConfig.myOptions.isDesktop [ ./desktop ])
    ++ (lib.optionals osConfig.myOptions.isLaptop [ ./laptop ])
    ++ (lib.optionals osConfig.myOptions.isServer [ ./server ]);

  home = {
    username = osConfig.myOptions.username;
    homeDirectory = "/home/${osConfig.myOptions.username}";

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      GDK_BACKEND = "wayland,x11";
      EDITOR = "nvim";
      GRIMBLAST_EDITOR = "swappy";
    };

    stateVersion = osConfig.system.stateVersion;
  };
}
