{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , nixpkgs-unstable
    , disko
    , home-manager
    , ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      unstable = import nixpkgs-unstable {
        inherit system; config = { allowUnfree = true; };
      };
      extraSpecialArgs = { inherit system inputs unstable; };
    in
    {
      nixpkgs = {
        overlays = [
          (final: prev: {
            nvchad = inputs.nix4nvchad.packages."${pkgs.system}".nvchad;
          })
        ];
      };
      nixosConfigurations = {
        nimbus = nixpkgs.lib.nixosSystem {
          inherit system;
          inherit unstable;

          modules = [
            ./hosts/nimbus
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                inherit extraSpecialArgs;
                useGlobalPkgs = true;
                useUserPackages = true;
                users.benji = import ./home/nimbus;
              };
            }
          ];
        };
        comet = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            disko.nixosModules.disko
            ./hosts/comet
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                inherit extraSpecialArgs;
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "hm-backup";
                users.benji = import ./home/comet;
              };
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
              inherit pkgs;
              extraSpecialArgs = { inherit unstable; };

            };
          "benji@nimbus" =
            home-manager.lib.homeManagerConfiguration {
              modules = [ (import ./home/nimbus) ];
              inherit pkgs;
              extraSpecialArgs = { inherit unstable; };
            };
        };

      # if pre-commit is not found, enter devshell with `nix develop` to reset it.
      formatter = {
        x86_64-linux = pkgs.nixfmt;
      };
      
      checks = {
        x86_64-linux = {
          pre-commit-check = inputs.pre-commit-hooks.lib.x86_64-linux.run {
            src = ./.;
            hooks = {
              nixfmt.enable = true;
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
