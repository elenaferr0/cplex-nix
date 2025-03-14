# CPLEX Nix Environment

This is a Nix flake template for setting up an IBM ILOG CPLEX Optimization Studio environment.

## Prerequisites

- Nix with flakes enabled
- An IBM CPLEX installer (you need to download this yourself from IBM)

## Setup Instructions

1. Initialize a new project from this template:
   ```
   nix flake init -t github:your-username/cplex-flake
   ```

2. Download your CPLEX installer from IBM:
   https://www.ibm.com/support/pages/downloading-ibm-ilog-cplex-optimization-studio-2212

3. Update the `flake.nix` file to point to your CPLEX installer:
   ```nix
   cplex = pkgs.callPackage ./cplex.nix {
     releasePath = ./path/to/your/cplex.bin;
   };
   ```

4. Update the `devShell` section to include the cplex package:
   ```nix
   buildInputs = [
     cplex
     pkgs.curl
     pkgs.python3
     # Other packages...
   ];
   ```

5. Enter the development environment:
   ```
   nix develop
   ```

## Environment Variables

When properly configured, the environment sets up:
- `CPLEX_STUDIO_DIR`: Points to the CPLEX installation
- `CPLEX_BIN_DIR`: Points to the CPLEX binary directory
- `LD_LIBRARY_PATH`: Includes the CPLEX library path

## License

The CPLEX software requires a valid license from IBM. This template only helps with the Nix environment setup.
