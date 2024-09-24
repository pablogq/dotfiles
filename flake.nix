{
  description = "Pablo's system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager }:
    let
      inherit (nixpkgs.lib) makeOverridable;
      x86_64-darwin = "x86_64-darwin";
      aarch64-darwin = "aarch64-darwin";
      configuration = { ... }: {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.pablogq = import ./home;
        nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [];
      };
    in
    {
      darwinConfigurations = rec {
        # Build darwin flake using:
        # $ darwin-rebuild build --flake .#macbookpro-arm
        macbookpro-arm = makeOverridable nix-darwin.lib.darwinSystem {
          system = aarch64-darwin;
          modules = [
            ./darwin
            home-manager.darwinModules.home-manager
            configuration
          ];
        };

        # Build darwin flake using:
        # $ darwin-rebuild build --flake .#macbookpro-x86
        macbookpro-x86 = macbookpro-arm.override { system = x86_64-darwin; };
      };
    };
}
