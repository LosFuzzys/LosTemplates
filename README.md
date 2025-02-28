# LosTemplates - CTF Challenge Templates

Challenge templates for CTFs as you go! Sane defaults, simplified complexity,
automated workflows, integrated sanity checking, and deployable everywhere.

Just copy any folder you'd like to your CTF repository to start with.

## Versions

The following table lists the template and the latest version.

| Name                           | Version |
| :----------------------------- | :-----: |
| bash-jail-ubuntu24.04          | 1.0.0   |
| bash-nojail-ubuntu24.04        | 1.0.0   |
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

The Makefile a number of targets, the most important ones as a challenge-author are the following:
* version
* all
* build
* run
* solve
* kill
* dist

### version
This targets prints the type of the makefile in use and the current version-number.
It can be used to debug errors and is useful for us when determining if the template is up to date or if it is missing important fixes.
```console
$ make version 
[+] Template offline version 1.0.0
```

### all
This target is a wrapper for [build](#build) and [run](#run).
It build or rebuilds the challenge-image and then starts a container.

### build
This target builds the Dockerimage of the challenge as specified by the Dockefile.
The dockerfile being used is the one on the same level as the Makefile.
Depending on the template, this target might not be implemented (e.g. for the *offline*-template).
For *pwn*-challenges, build (which uses [cbuild](#cbuild)) also rebuilds pwn-binaries.

Because the target wraps the `cbuild`-target, you get the information that `cbuild` is not implemented.
```console
$ make build
[+] (cbuild) Not implemented in this template
```
> [!NOTE]
> This target wraps [cbuild](#cbuild).

### run
This target starts a container running the challenge.
Depending on the template, this target might not be implemented (e.g. for the *offline*-template).

Because the target wraps the `crun`-target, you get the information that `crun` is not implemented.
```console
$ make run
[+] (crun) Not implemented in this template
```

> [!NOTE]
> This target wraps [crun](#crun).

### solve

> [!NOTE]
> This target wraps [sbuild](#sbuild) and [srun](#srun).

### kill

> [!NOTE]
> This target wraps [ckill](#ckill) and [skill](#skill).

### dist
This target creates a `<name>.tar.gz`-archive of the files in the dist-folder.
In addition, it also creates a file containing all the checksums.
This checksum-file can be used by the user to determine if he changed some files (mainly important for *pwn*-challenges).

The file is creates such that `<name>` is the name of the folder that the makefile is in.


### Other targets

#### cbuild
#### crun
#### ckill

#### sbuild
#### srun
#### srun-sequential
#### srun-parallel
#### skill

#### deploy
#### deploy-yml
#### deploy-quadlet
#### deploy-registry



TODO
