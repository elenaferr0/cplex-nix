{
  description = "CPLEX optimization environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        # Import the cplex package
        cplex = pkgs.callPackage ./cplex.nix {
          # User must override this with their own CPLEX installer
          releasePath = null; 
        };
      in
      {
        packages.cplex = cplex;
        
        devShell = pkgs.mkShell {
          name = "cplex-environment";
          
          buildInputs = [
            # Note: cplex will need to be configured with releasePath before it can be included here
            pkgs.curl
            pkgs.python3
            # Add any additional tools you might need
          ];
          
          shellHook = ''
            echo "CPLEX environment template"
            echo ""
            echo "Before using this environment, you need to:"
            echo "1. Download the CPLEX installer from IBM"
            echo "2. Update the flake.nix file to specify the path to your CPLEX installer"
            echo ""
            echo "Example modification:"
            echo "cplex = pkgs.callPackage ./cplex.nix {"
            echo "  releasePath = ./path/to/your/cplex.bin;"
            echo "};"
          '';
        };
      });
}
