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
            if [ -n "${toString cplex}" ] && [ "${toString cplex}" != "«derivation»" ]; then
              # These will only be set if cplex is properly configured
              export CPLEX_STUDIO_DIR=${cplex}
              export CPLEX_BIN_DIR=${cplex}/cplex/bin/x86-64_linux
              
              # Only add to LD_LIBRARY_PATH if the directory exists
              if [ -d "${cplex}/cplex/bin/x86-64_linux" ]; then
                export LD_LIBRARY_PATH=${cplex}/cplex/bin/x86-64_linux:$LD_LIBRARY_PATH
              fi
              
              echo "CPLEX 22.12 environment loaded!"
              if [ -f "${cplex}/bin/cplex" ]; then
                echo "You can run CPLEX using the 'cplex' command"
              else
                echo "Warning: CPLEX binary not found at expected location"
                echo "Look for CPLEX binaries in: ${cplex}/cplex/bin/x86-64_linux"
              fi
            else
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
              echo ""
              echo "After updating, remember to add cplex to buildInputs:"
              echo "buildInputs = ["
              echo "  cplex"
              echo "  pkgs.curl"
              echo "  # Other packages..."
              echo "];"
            fi
          '';
        };
      });
}
