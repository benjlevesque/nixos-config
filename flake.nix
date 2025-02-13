{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , disko
    , home-manager
    , ...
    }:
    {
      nixosConfigurations = {
        nimbus = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/nimbus
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.benji = import ./home/nimbus;

              # Optionally, use home-manager.extraSpecialArgs to pass
              # arguments to home.nix
            }
          ];
        };
        comet = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            disko.nixosModules.disko
            ./hosts/comet
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "hm-backup";
              home-manager.users.benji = import ./home/comet;

              # Optionally, use home-manager.extraSpecialArgs to pass
              # arguments to home.nix
            }
          ];
        };

      };
      # enable home-manager switch
      homeConfigurations =
        {
          "benji@comet" =
            home-manager.lib.homeManagerConfiguration {
              modules = [ (import ./home/comet) ];
              pkgs = nixpkgs.legacyPackages.x86_64-linux;
            };
          "benji@nimbus" =
            home-manager.lib.homeManagerConfiguration {
              modules = [ (import ./home/nimbus) ];
              pkgs = nixpkgs.legacyPackages.x86_64-linux;
            };
        };

      checks = {
        x86_64-linux = {
          pre-commit-check = inputs.pre-commit-hooks.lib.x86_64-linux.run {
            src = ./.;
            hooks = {
              nixpkgs-fmt.enable = true;
            };
          };
        };
      };
      devShells = {
        x86_64-linux = {
          default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
            inherit (self.checks.x86_64-linux.pre-commit-check) shellHook;
            buildInputs = self.checks.x86_64-linux.pre-commit-check.enabledPackages;
          };
        };
      };

    };
}
