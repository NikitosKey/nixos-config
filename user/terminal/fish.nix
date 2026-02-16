# ~/nixos-config/home-manager/cli/aliases.nix
{ pkgs, ...}:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    plugins = [
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }
    ];
    shellAliases = {
      nrbs = "sudo nixos-rebuild switch --flake ~/nixos-config#macbookpro";
      nrbt = "sudo nixos-rebuild test --flake ~/nixos-config#macbookpro";
      nfu = "nix flake update ~/nixos-config";
      gc = "sudo nix-collect-garbage -d";
      nv = "nvim";
      ssh = "kitten ssh";
    };
  };
}
