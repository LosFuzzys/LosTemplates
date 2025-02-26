{
  description = "Glacier";
  nixConfig.bash-prompt = "\[🏔️\]$ ";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    utils,
    ...
  } @ inputs:
    utils.lib.eachDefaultSystem (
      system: let
        p = import nixpkgs {inherit system;};
      in {
        devShell = p.mkShell.override {stdenv = p.stdenv;} {
          packages = with p; [
            gettext
            parallel
            gnumake
            gnutar
            coreutils
            bash
            podman
            zsh
            (writeShellScriptBin "docker" ''
              HOME=$BASEPATH exec podman "$@"
            '')
          ];

          shellHook = ''
            export BASEPATH="$PWD"
          '';
          name = "Template Dependencies";
        };
      }
    );
}
