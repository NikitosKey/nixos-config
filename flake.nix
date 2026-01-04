# ~/nixos-config/flake.nix
{
  description = "Похуй мне";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/c5ae371f1a6a7fd27823";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
        url = "github:nix-community/nixvim";
        # If using a stable channel you can use `url = "github:nix-community/nixvim/nixos-<version>"`
        inputs.nixpkgs.follows = "nixpkgs";
    };
#		anyrun = {
#			url = "github:anyrun-org/anyrun";
#			inputs.nixpkgs.follows = "nixpkgs";
#		};
		mcmojave-hyprcursor.url = "github:libadoxon/mcmojave-hyprcursor";
    apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, apple-silicon, nixvim, mcmojave-hyprcursor, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = { inherit inputs apple-silicon self; };
      modules = [
        apple-silicon.nixosModules.default
        ./nixos/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
					home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.nikitoskey = {
            imports = [
#							({ modulesPath, ... }: {
#								disabledModules = [ "${modulesPath}/programs/anyrun.nix" ];
#						  })
             ./home/home.nix
             nixvim.homeModules.nixvim
#     				anyrun.homeManagerModules.default
            ];
          };
          home-manager.backupFileExtension = "bkg";
        }
      ];
    };
  };
}
