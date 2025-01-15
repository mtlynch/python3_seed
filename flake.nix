{
  description = "Demo Nix dev environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    # 3.12.0 release
    python-nixpkgs.url = "github:NixOS/nixpkgs/e2b8feae8470705c3f331901ae057da3095cea10";

    # 0.5.18
    uv-nixpkgs.url = "github:NixOS/nixpkgs/2b1fca3296ddd1602d2c4f104a4050e006f4b0cb";
  };

  outputs = {
    self,
    flake-utils,
    python-nixpkgs,
    uv-nixpkgs,
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: let
      python-nixpkgs = inputs.python-nixpkgs.legacyPackages.${system};
      uv = inputs.uv-nixpkgs.legacyPackages.${system}.uv;
    in {
      formatter = python-nixpkgs.alejandra;

      devShells.default = python-nixpkgs.mkShell {
        packages = [
          python-nixpkgs.python312
          uv
        ];

        shellHook = ''
          python --version
          uv --version
        '';
      };
    });
}
