# This shell.nix just provides all dependencies for running the makefiles from LosTemplates.
# Except docker. Install that in your system if you havn't already.
{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  packages = with pkgs; [
    gnumake
    gnutar
    parallel
    envsubst
    git
  ];
  shellHook = ''
    RED='\033[0;31m'
    NC='\033[0m' # No Color
    command -v docker
    if [ $? -ne 0 ]; then
      echo
      echo -e "''${RED}NO DOCKER COMMAND FOUND!''${NC}"
      echo
      echo "Dear nix user,"
      echo "while this nix shell provides you with most commands needed to run every challenge in this repo,"
      echo "you need a system install of docker or podman mapped to docker. Cheers!"
      echo
      echo
    fi
  '';
}
