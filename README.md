# Template Guidelines

Challenge templates for CTFs as you go! Sane defaults, simplified complexity,
automated workflows, integrated sanity checking, and deployable everywhere.

Just copy any folder you'd like to your CTF repository to start with.

## Dependencies

### Deployment

Install `docker`, `bash`, `make`, GNU `envsubst`, GNU `tar`, GNU `coreutils` and `parallel`.

**Ubuntu**:
```
# Ubuntu 24.04
sudo apt install bash make gettext tar coreutils parallel
# Install podman or docker at your choice
sudo apt install podman podman-docker
```

**Fedora**:
```
# Fedora 41
sudo dnf install bash make gettext-envsubst tar coreutils parallel
# Install podman or docker at your choice
sudo dnf install podman podman-docker
```

All templates have been tested on Fedora 41 and default Ubuntu 24.04 with podman and docker.

### Players via dist `.tar.gz`

Install `docker`, `tar` and a linux shell.

## Usage

TODO
