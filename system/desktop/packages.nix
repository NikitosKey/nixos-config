# ~/nixos-config/nixos/packages.nix
{ inputs, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    snixembed
    unstable.firefox
    unstable.thunderbird
    unstable.qemu
  ];
}
