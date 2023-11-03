{
  inputs = {
    cargo2nix.url = "github:cargo2nix/cargo2nix/release-0.11.0";
    flake-utils.follows = "cargo2nix/flake-utils";
    nixpkgs.follows = "cargo2nix/nixpkgs";
  };

  outputs = { flake-utils, cargo2nix, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ cargo2nix.overlays.default ];
        };

        rustPkgs = pkgs.rustBuilder.makePackageSet {
          rustVersion = "1.70.0";
          packageFun = import ./Cargo.nix;
        };

      in rec {
        packages = {
          fennel-language-server =
            rustPkgs.workspace.fennel-language-server { };
          default = packages.fennel-language-server;
        };
      });
}
