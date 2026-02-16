# ~/nixos-config/nixos/packages.nix
{ inputs, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
  ];
}
