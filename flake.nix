{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks.url = "github:cachix/git-hooks.nix";
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
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      disko,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      unstable = import nixpkgs-unstable {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
      extraSpecialArgs = { inherit system inputs unstable; };
      forEachSystem = nixpkgs.lib.genAttrs [ system ];
    in
    {
      nixosConfigurations = {
        nimbus = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit unstable; };

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
      homeConfigurations = {
        "benji@comet" = home-manager.lib.homeManagerConfiguration {
          modules = [ (import ./home/comet) ];
          inherit pkgs;
          extraSpecialArgs = { inherit inputs unstable; };

        };
        "benji@nimbus" = home-manager.lib.homeManagerConfiguration {
          modules = [ (import ./home/nimbus) ];
          inherit pkgs;
          extraSpecialArgs = { inherit inputs unstable; };
        };
      };

      # if pre-commit is not found, enter devshell with `nix develop` to reset it.
      formatter = {
        x86_64-linux = pkgs.nixfmt;
      };

      # Run the hooks in a sandbox with `nix flake check`.
      # Read-only filesystem and no internet access.
      checks = forEachSystem (system: {
        pre-commit-check = inputs.git-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixfmt.enable = true;
          };
        };
      });

      # Enter a development shell with `nix develop`.
      # The hooks will be installed automatically.
      # Or run pre-commit manually with `nix develop -c pre-commit run --all-files`
      devShells = forEachSystem (system: {
        default =
          let
            pkgs = nixpkgs.legacyPackages.${system};
            inherit (self.checks.${system}.pre-commit-check) shellHook enabledPackages;
          in
          pkgs.mkShell {
            inherit shellHook;
            buildInputs = enabledPackages;
          };
      });
    };
}
