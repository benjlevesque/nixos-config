{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
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
    in
    {
      nixosConfigurations = {
        nimbus = nixpkgs.lib.nixosSystem {
          inherit system;
          inherit unstable;

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
          inherit system;
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
              inherit pkgs;
              extraSpecialArgs = { inherit unstable; };

            };
          "benji@nimbus" =
            home-manager.lib.homeManagerConfiguration {
              modules = [ (import./home/nimbus) ];
              inherit pkgs;
              extraSpecialArgs = { inherit unstable; };
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
