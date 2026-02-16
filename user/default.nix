# ~/nixos-config/user/default.nix
{ self, osConfig, inputs, pkgs, nixpkgs, ... }:
{
  imports = [
    ./terminal 
  ];

  home.username = "nikitoskey";
  home.homeDirectory = "/home/nikitoskey";

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1"; 
    GDK_BACKEND = "wayland,x11";
    EDITOR = "nvim";
    GRIMBLAST_EDITOR = "swappy";
  };

  home.stateVersion = osConfig.system.stateVersion;
}
