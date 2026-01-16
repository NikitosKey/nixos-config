# nixos-config/system/default.nix
{ pkgs, inputs, config, lib, ... }: {
  imports = [
    inputs.stylix.homeManagerModules.stylix

    ./users.nix
    ./packages.nix
  ];

	nix = {
		settings = {
			experimental-features = [ "nix-command" "flakes" ];
			auto-optimise-store = true;
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

  i18n.defaultLocale = "ru_RU.UTF-8";
  console = {
    earlySetup = true;
    font = "ter-u32n";
    packages = with pkgs; [ terminus_font ];
    keyMap = "ru";
  };

  time.timeZone = "Europe/Moscow"; 
}
