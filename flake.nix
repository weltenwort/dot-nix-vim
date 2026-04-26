{
  description = "nixvim flake";

  inputs = {
    nixpkgs = {
      follows = "nixvim/nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      flake = { };
      systems = [
        "aarch64-linux"
        "x86_64-linux"
        "aarch64-darwin"
      ];
      perSystem =
        { pkgs, system, ... }:
        let
          nixvim = inputs.nixvim.legacyPackages.${system};
          simpleNvim = nixvim.makeNixvimWithModule {
            inherit pkgs;
            module = import ./simple.nix;
          };
        in
        {
          packages = {
            default = simpleNvim;
            simple = simpleNvim;
          };
        };
    };

}
