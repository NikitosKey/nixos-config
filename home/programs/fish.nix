# ~/nixos-config/home-manager/cli/aliases.nix
{ pkgs, ...}:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    plugins = [
      # Enable a plugin (here grc for colorized command output) from nixpkgs
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }
    ];
    shellAliases = {
      # Обновленный алиас для флейков
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config#nixos";
      update = "nix flake update ~/nixos-config";
      gc = "sudo nix-collect-garbage -d";
    };
  };
}
