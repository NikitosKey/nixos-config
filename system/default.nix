# nixos-config/system/default.nix
{ pkgs, inputs, config, lib, ... }: {
  imports = [
    ./users.nix
    ./terminal
  ];

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" "nikitoskey" ];
      auto-optimise-store = true;
      substitute = true;
      substituters = [
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
        "https://yazi.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
      ];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
	};

  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
    config = {
      allowUnfree = true;
      allowUnsupportedSystem = true;
    };
  };

  environment.sessionVariables = {
    EDITOR = "nvim";
  };

  i18n.defaultLocale = "ru_RU.UTF-8";
  console = {
    earlySetup = true;
    font = "ter-u32n";
    packages = with pkgs; [ terminus_font ];
    keyMap = "ru";
  };

  time.timeZone = "Europe/Moscow"; 
}
