# LosTemplates - CTF Challenge Templates

Challenge templates for CTFs as you go! Sane defaults, simplified complexity,
automated workflows, integrated sanity checking, and deployable everywhere.

Just copy any folder you'd like to your CTF repository to start with.

## Versions

The following table lists the template and the latest version.

| Name                           | Version |
| :----------------------------- | :-----: |
| flask-instanced-alpine3.19     | 1.0.0   |
| flask-nojail-alpine3.19        | 1.0.0   |
| offline                        | 1.0.0   |
| php-instanced-ubuntu24.04      | 1.0.0   |
| php-nojail-ubuntu24.04         | 1.0.0   |
| phpxss-nojail-ubuntu24.04      | 1.0.0   |
| pwn-jail-alpine3.19            | 1.0.0   |
| pwn-jail-ubuntu24.04           | 1.0.0   |
| pwn-nojail-alpine3.19          | 1.0.0   |
| pwn-nojail-ubuntu24.04         | 1.0.0   |
| pwn-qemu-kernel                | 1.0.0   |
| python3.11-jail-alpine3.19     | 1.0.0   |
| python3.11-nojail-alpine3.19   | 1.0.0   |
| python3.12-jail-ubuntu24.04    | 1.0.0   |
| python3.12-nojail-ubuntu24.04  | 1.0.0   |
| rust-nojail-alpine3.19         | 1.0.0   |
| rust-nojail-ubuntu24.04        | 1.0.0   |
| sagemath-nojail-ubuntu22.04    | 1.0.0   |
| solidity-nojail-debian11       | 1.0.0   |


## Dependencies

### Challenge Author

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

### Challenge Player

Install `docker`, `tar` and a linux shell.

## Usage

TODO
