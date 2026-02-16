# system/desktop/default.nix
{
  imports = [
    ./greetd.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./udisks2.nix
    ./stylix.nix
    ./fonts.nix
    ./v2raya.nix
    ./packages.nix
    ./gvfs.nix
    ./audio.nix
    ./power-management.nix
  ];
}
