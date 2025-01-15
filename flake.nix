{
  description = "Demo Nix dev environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    # 3.12.0 release
    python-nixpkgs.url = "github:NixOS/nixpkgs/e2b8feae8470705c3f331901ae057da3095cea10";
  };

  outputs = {
    self,
    flake-utils,
    python-nixpkgs,
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: let
      python-nixpkgs = inputs.python-nixpkgs.legacyPackages.${system};
    in {
      formatter = python-nixpkgs.alejandra;

      devShells.default = python-nixpkgs.mkShell {
        packages = [
          python-nixpkgs.python312
        ];

        shellHook = ''
          python --version
        '';
      };
    });
}
