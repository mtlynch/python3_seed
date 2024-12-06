{
  description = "Create Nix development environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    # Python 3.12.0 release
    python-nixpkgs.url = "github:NixOS/nixpkgs/e2b8feae8470705c3f331901ae057da3095cea10";

    pyproject-nix = {
      url = "github:nix-community/pyproject.nix";
      flake = false;
    };
  };

  outputs = {
    self,
    python-nixpkgs,
    flake-utils,
    pyproject-nix,
  } @ inputs: let
    pyproject = import (pyproject-nix + "/lib") {inherit (python-nixpkgs) lib;};

    project = pyproject.project.loadRequirementsTxt {
      requirements = ./dev_requirements.txt;
    };
  in
    flake-utils.lib.eachDefaultSystem (system: let
      python = python-nixpkgs.legacyPackages.${system}.python3;

      pythonEnv = python-nixpkgs.legacyPackages.${system}.python3.withPackages (
        pyproject.renderers.withPackages {
          inherit project python;
        }
      );
    in {
      formatter = python-nixpkgs.legacyPackages.${system}.alejandra;

      devShells.default = python-nixpkgs.legacyPackages.${system}.mkShell {
        packages = [
          pythonEnv
        ];

        shellHook = ''
          python --version
        '';
      };
    });
}
