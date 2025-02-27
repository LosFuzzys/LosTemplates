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
        podman_policy = p.writeText "policy.json" ''
          {
            "default":
            [
              {
                "type": "insecureAcceptAnything"
              }
            ]
          }
        '';
        patched_podman = p.podman.overrideAttrs (old: {
          name = "LosPodman";
          preBuild = ''
            find . -type f -exec sed -i 's|/etc/containers/policy.json|${podman_policy}|' {} \;
          '';
        });
      in {
        devShell = p.mkShell.override {stdenv = p.stdenv;} {
          packages = with p; [
            gettext
            parallel
            gnumake
            gnutar
            coreutils
            bash
            patched_podman
            (writeShellScriptBin "docker" ''
              exec podman "$@"
            '')
          ];
          name = "Template Dependencies";
        };
      }
    );
}
