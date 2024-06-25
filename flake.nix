{
  description = "system configuration for minio";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    common.url = "github:stary2001/nix-common";
  };

  outputs = inputs:
    let system = "x86_64-linux";
    in {
      formatter.${system} = inputs.nixpkgs.legacyPackages.${system}.nixfmt;

      homeConfigurations.default =
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.${system};
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ({ config, ... }: {
              imports = [ inputs.common.homeModules.base ];
              _module.args = {
                unstable = import inputs.nixpkgs-unstable {
                  inherit system;
                  inherit (config.nixpkgs) config overlays;
                };
              };
            })
          ];
        };

      nixosConfigurations.default = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ({ config, ... }: {
            imports = [
              ./system.nix
              ./nginx.nix
              ./hardware-configuration.nix

              inputs.common.nixosModules.base
              inputs.common.nixosModules.prometheus-exporter
              inputs.common.nixosModules.loki-ingest
              inputs.common.nixosModules.auto-upgrade
              inputs.common.nixosModules.wait-online-any
            ];
            _module.args = {
              unstable = import inputs.nixpkgs-unstable {
                inherit system;
                inherit (config.nixpkgs) config overlays;
              };
            };

            system.stateVersion = "24.05";
          })
        ];
      };
    };
}
