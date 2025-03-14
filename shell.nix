{ pkgs ? import <nixpkgs> {} }:

let
  cplex = pkgs.callPackage ./cplex.nix {
    releasePath = ./cplex.bin;
    curl = pkgs.curl;
  };
in
pkgs.mkShell {
  name = "cplex-environment";
  
  buildInputs = [
    cplex
    pkgs.curl
    # Add any additional tools you might need
    pkgs.python3 # Optional: if you want to use Python with CPLEX
    # pkgs.gcc # Uncomment if you need a C compiler
    # pkgs.gdb # Uncomment if you need a debugger
  ];

  # Set environment variables if needed
  shellHook = ''
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
  '';
}
