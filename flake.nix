{
  description = "CPLEX optimization environment template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        templates.default = {
          path = ./template;
          description = "CPLEX optimization environment template";
        };
      }) // {
        templates.default = {
          path = ./template;
          description = "CPLEX optimization environment template";
        };
      };
}
