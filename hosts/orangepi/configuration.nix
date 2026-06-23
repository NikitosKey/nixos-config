# hosts/orangepi5ultra/configuration.nix
{ config, pkgs, lib, self, inputs, ... }:
{
  imports = [
    ./hardware.nix
    ../../modules/minecraft.nix
    ../../modules/obsidian-livesync.nix
    ../../modules/nextcloud.nix
  ];

  myOptions.isServer = true;

  nixpkgs = {
    hostPlatform = lib.mkForce "aarch64-linux";
  };

  system.stateVersion = "26.05";
}
