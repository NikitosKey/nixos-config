{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
    shellAliases = {
      gc = "sudo nix-collect-garbage -d";
      nv = "nvim";
      ssh = "kitten ssh";
      grbs = "sudo nixos-rebuild switch --flake github:NikitosKey/nixos-config";
      grbt = "sudo nixos-rebuild test --flake github:NikitosKey/nixos-config";
    }; 
  };
}
