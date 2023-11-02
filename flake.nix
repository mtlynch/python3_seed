{
  description = "Create Nix development environment";

  # Python 3.12.0 release
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/e2b8feae8470705c3f331901ae057da3095cea10";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  inputs.pyproject-nix.url = "github:nix-community/pyproject.nix";
  # Don't use the pyproject.nix flake directly to avoid its inputs in our
  # closure.
  inputs.pyproject-nix.flake = false;

  outputs = { self, nixpkgs, flake-utils, pyproject-nix  }:
    let
      pyproject = import (pyproject-nix + "/lib") { inherit (nixpkgs) lib; };

      # Load/parse dev_requirements.txt
      project = pyproject.project.loadRequirementsTxt {
        requirements = ./dev_requirements.txt;
      };

    in
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      python = pkgs.python3;

      pythonEnv = (
          # Render requirements.txt into a Python withPackages environment.
          pkgs.python3.withPackages (pyproject.renderers.withPackages {
            inherit project python;
          })
        );
    in
    {
      devShell =
        pkgs.mkShell {
          packages = [
            pythonEnv
          ];
          shellHook = ''
            python --version
          '';
        };
    });
}
