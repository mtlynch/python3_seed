{
  description = "Create Nix development environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # 0.9.7
    uv-nixpkgs.url = "github:NixOS/nixpkgs/1d4c88323ac36805d09657d13a5273aea1b34f0c";
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
    uv-nixpkgs,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      uv = uv-nixpkgs.legacyPackages.${system}.uv;
    in {
      formatter = pkgs.alejandra;

      devShells.default = pkgs.mkShell {
        packages = [
          pkgs.python313
          uv
        ];

        shellHook = ''
          uv --version
          python --version
          if [ -d .venv/bin ]; then
            export VIRTUAL_ENV="$PWD/.venv"
            export PATH="$PWD/.venv/bin:$PATH"
          fi
        '';
      };
    });
}
