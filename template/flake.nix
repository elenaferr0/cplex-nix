{
  description = "CPLEX optimization environment for C++ development";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      # Import the cplex package
      cplex = pkgs.callPackage ./cplex.nix {
        # User must override this with their own CPLEX installer
        releasePath = ~/Documents/cplex.bin;
      };
    in {
      packages.cplex = cplex;
      devShell = pkgs.mkShell {
        name = "cplex-cpp-env";
        buildInputs = [
          cplex
          pkgs.gcc
          pkgs.gdb
          pkgs.gnumake
        ];
        packages = [];
        shellHook = ''
          if [ -n "${toString cplex}" ] && [ "${toString cplex}" != "«derivation»" ]; then
            # These will only be set if cplex is properly configured
            export CPLEX_STUDIO_DIR2211=${cplex}
            export CPLEX_BIN_DIR=${cplex}/cplex/bin/x86-64_linux
            export CPLEX_INCLUDE_DIR=${cplex}/cplex/include
            export CPLEX_LIB_DIR=${cplex}/cplex/lib/x86-64_linux/static_pic
            
            # Only add to LD_LIBRARY_PATH if the directory exists
            if [ -d "${cplex}/cplex/bin/x86-64_linux" ]; then
              export LD_LIBRARY_PATH=${cplex}/cplex/bin/x86-64_linux:$LD_LIBRARY_PATH
            fi
            
            # Set up for C++ compilation with CPLEX
            export CPATH=$CPATH:${cplex}/cplex/include:${cplex}/concert/include
            export LIBRARY_PATH=$LIBRARY_PATH:${cplex}/cplex/lib/x86-64_linux/static_pic:${cplex}/concert/lib/x86-64_linux/static_pic
            export LDFLAGS="-L${cplex}/cplex/lib/x86-64_linux/static_pic -L${cplex}/concert/lib/x86-64_linux/static_pic -lilocplex -lconcert -lcplex -lm -lpthread -ldl"
            
            echo "CPLEX 22.12 C++ development environment loaded!"
            echo "C++ compiler: $(gcc --version | head -n 1)"
            echo ""
            echo "To compile a C++ program with CPLEX:"
            echo "g++ -I${cplex}/cplex/include -I${cplex}/concert/include your_program.cpp -L${cplex}/cplex/lib/x86-64_linux/static_pic -L${cplex}/concert/lib/x86-64_linux/static_pic -lilocplex -lconcert -lcplex -lm -lpthread -ldl -o your_program"
            echo ""
            if [ -f "${cplex}/bin/cplex" ]; then
              echo "You can run CPLEX using the 'cplex' command"
            else
              echo "Warning: CPLEX binary not found at expected location"
              echo "Look for CPLEX binaries in: ${cplex}/cplex/bin/x86-64_linux"
            fi
          else
            echo "CPLEX C++ development environment template"
            echo ""
            echo "Before using this environment, you need to:"
            echo "1. Download the CPLEX installer from IBM"
            echo "2. Update the flake.nix file to specify the path to your CPLEX installer"
            echo ""
            echo "Example modification:"
            echo "cplex = pkgs.callPackage ./cplex.nix {"
            echo "  releasePath = ./path/to/your/cplex.bin;"
            echo "};"
          fi
        '';
      };
    });
}
