{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mcp-servers-nix.url = "github:natsukium/mcp-servers-nix";
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      stylix,
      plasma-manager,
      lanzaboote,
      nixvim,
      ...
    }:
    let
      system = "x86_64-linux";
      overlays = [
        (final: prev: {
          unstable = import nixpkgs-unstable {
            inherit system;
            config = prev.config;
          };
        })
      ];
      pkgs = nixpkgs.legacyPackages.${system}.extend overlays;
    in
    {
      nixosConfigurations.pc = nixpkgs.lib.nixosSystem {
        system = system;
        modules = [
          {
            nixpkgs = {
              inherit system;
              config.allowUnfree = true;
              overlays = overlays;
            };
          }

          ./hosts/pc/configuration.nix

          home-manager.nixosModules.home-manager
          stylix.nixosModules.stylix
          lanzaboote.nixosModules.lanzaboote
          nixvim.nixosModules.nixvim

          {
            home-manager = {
              useGlobalPkgs = true;
              backupFileExtension = "backup";
              users.andrei = import ./users/andrei.nix;
              users.andrei01tech = import ./users/andrei01tech.nix;
              extraSpecialArgs = { inherit nixvim; };
              sharedModules = [
                plasma-manager.homeModules.plasma-manager
                nixvim.homeModules.nixvim
              ];
            };
          }
        ];
      };
      formatter.${system} = pkgs.nixfmt-tree;
    };
}
