# CPLEX Nix Environment
This is a Nix flake template for setting up an IBM ILOG CPLEX Optimization Studio environment.

# Motivation
I had the need to create this because the [nixpkgs](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/science/math/cplex/default.nix) cplex installer was failing during `installPhase` with this error:
```
Running phase: installPhase
mv: cannot stat '/nix/store/rwnwq5m6fhc0vsyrzg9p890i40hbsjyr-cplex-22.12/doc': No such file or directory
       > Running phase: installPhase
       > mv: cannot stat '/nix/store/rwnwq5m6fhc0vsyrzg9p890i40hbsjyr-cplex-22.12/doc': No such file or directory
       For full logs, run 'nix log /nix/store/333yavk6iq6442jwaci1bhwsrdny8x79-cplex-22.12.drv'.
```
Which seems to occur if `doc` or `license` directories are not found in the installation path. This issue has been addressed by conditionally checking their existance [here](https://github.com/elenaferr0/cplex-nix/blob/d3729e78999a9aaf1a339f825d7e080f66316f8f/template/cplex.nix#L86) as following:

```bash
    if [ -d "$out/doc" ]; then
      mkdir -p $out/share/doc
      mv $out/doc $out/share/doc/$name
    else
      echo "No doc directory found, skipping doc installation"
    fi

    if [ -d "$out/license" ]; then
      mkdir -p $out/share/licenses
      mv $out/license $out/share/licenses/$name
    else
      echo "No license directory found, skipping license installation"
    fi
```

Furthermore this also allows upgrading to cplex latest version (22.12).

## Prerequisites

- Nix with flakes enabled
- An IBM CPLEX installer (you need to download this yourself from IBM)

## Setup Instructions

1. Initialize a new project from this template:
   ```bash
   nix flake init -t github:elenaferr0/cplex-nix
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
   ```bash
   nix develop -c $SHELL
   ```
   In case you did not enable unfree packages you will need to run the following command instead:
   ```bash
   NIXPKGS_ALLOW_UNFREE=1 nix develop --impure -c $SHELL
   ```

## Environment Variables

When properly configured, the environment sets up:
- `CPLEX_STUDIO_DIR`: Points to the CPLEX installation
- `CPLEX_BIN_DIR`: Points to the CPLEX binary directory
- `LD_LIBRARY_PATH`: Includes the CPLEX library path

## License

The CPLEX software requires a valid license from IBM. This template only helps with the Nix environment setup.
