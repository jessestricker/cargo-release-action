{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    devshell.url = "github:numtide/devshell/master";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    devshell,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [devshell.overlay];
      };
    in {
      # nix develop
      devShells.default = pkgs.devshell.mkShell {
        devshell.name = "cargo-release-action";
        devshell.packages = ["nodejs"];
      };

      # nix fmt
      formatter = pkgs.alejandra;
    });
}
