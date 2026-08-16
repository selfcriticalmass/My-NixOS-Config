{
  description = "Rijan's NixOS Configuration Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Deliberately NO `follows = "nixpkgs"` here. Determinate builds only the
    # nix/nixd binaries (~200 MB) and is tested against its own pinned nixpkgs.
    # Forcing it onto nixos-unstable breaks its bundled patchset (boost 1.89).
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, determinate, ... }@inputs:
    let
      system = "x86_64-linux";

      customOverlay = final: prev: {
        plink2             = final.callPackage ./pkgs/plink2/default.nix { };
        mzmine             = final.callPackage ./pkgs/mzmine/default.nix { };
        snpeff             = final.callPackage ./pkgs/snpeff/default.nix { };
        edge-tts           = final.callPackage ./pkgs/edge-tts/default.nix { };
        ferrite            = final.callPackage ./pkgs/ferrite/default.nix { };

        pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
          (python-final: python-prev: {
            python-lsp-ruff = python-prev.python-lsp-ruff.overridePythonAttrs (_: {
              doCheck = false;
            });
          })
        ];
      };

    pkgs = import nixpkgs {
        inherit system;
        overlays = [ customOverlay ];
        config = {
          allowUnfree = true;
          permittedInsecurePackages = [
            "electron-39.8.10"
          ];
        };
      };

    in
    {
      nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs;
        };

        modules = [
          # Must be first to properly configure Nix
          determinate.nixosModules.default

          ({ pkgs, ... }: {
            nixpkgs = {
              hostPlatform = system;
              overlays = [ customOverlay ];
              config = {
                allowUnfree = true;
                permittedInsecurePackages = [
                  "electron-39.8.10"
                ];
              };
            };
          })

          ./hardware-configuration.nix
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];
      };

      # Expose custom packages so nix-update --flake can find them.
      # Independent import of the same nixpkgs rev, so derived store paths
      # deduplicate with the system config's evaluation.
      packages.${system} = {
        inherit (pkgs)
          plink2
          mzmine
          snpeff
          edge-tts
          ferrite;
      };
    };
}
