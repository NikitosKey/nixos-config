{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    unstable.qemu
  ];
}
