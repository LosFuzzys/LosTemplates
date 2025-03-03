# LosTemplates - CTF Challenge Templates

Challenge templates for CTFs as you go! Sane defaults, simplified complexity,
minimal dependencies, easily hackable and deployable everywhere.

Add this repository as a submodule to your CTF repository or manually download
and copy the folders.

## Versions

Latest version of every template. Check the template version of your challenge
with `make version`.

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

### Authors

Install `docker`, `bash`, `make`, GNU `envsubst`, GNU `tar`, GNU `coreutils`
and `parallel`.

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

**Arch**:
```
sudo pacman -S bash make gettext tar coreutils parallel
# Install podman or docker at your choice
sudo pacman -S docker
# If you prefer rootless docker, install it from AUR
# but check for the configuration in the wiki
yay docker-rootless-extras
```

**Nix**:

```
nix develop
```

### Players

For Linux: `docker`, `tar` and a linux shell.

For Windows: `docker` with WSL2 backend.

## Usage

All the template logic is implemented in the `Makefile` at the root of every
template folder. Every `Makefile` contains different targets, the most
importants being:

* all (default)
* solve
* dist
* distrun

Other targets might be helpful too:

* build
* run
* solve-sequential
* solve-parallel
* kill
* clean
* version

You can customize the templates for every challenge as long as:

- `make` targets behave the same way
- `nsjail` (or similar) is not disabled in `--privileged` templates

If you don't want to build the challenge from source and want to include a
precompiled binary, you can.

### all

This target is a wrapper for [build](#build) and [run](#run). It build or
rebuilds the challenge-image and then starts the challenge container.

Supports selecting the `HOST` and `PORT`:

```console
$ make HOST=0.0.0.0 PORT=8080
```

The default `HOST` and `PORT` is `127.0.0.1.1337`

> [!NOTE]
> This target wraps [build](#build) and [run](#run).

### build

This target builds the image of the challenge as specified by the Dockefile.
The name of the image is the slugified name of the folder.

The Dockerfile used is the one on the same level as the Makefile.

For changing the `docker build` arguments, modify `BARGS` in the `Makefile`

### run

This target starts the container running the challenge.

For changing the `docker run` arguments, modify `RARGS` in the `Makefile`

Supports selecting `HOST` and `PORT` as in [all](#all)

### solve

This target builds the Dockerfile in `/solution/Dockerfile` responsible for
solving the challenge.

For changing the `docker run` and `docker build` arguments, modify `SRARGS` and
`SBARGS` in the `Makefile` respectively.

Supports selecting the `HOST` and `PORT` to solve:

```console
$ make solve HOST=chall.glacierctf.com PORT=8080
```

The default `HOST` and `PORT` is `127.0.0.1.1337`

> [!NOTE]
> This target wraps [sbuild](#sbuild) and [srun](#srun).

### kill

This target stops all challenge-related containers (solvers and deployments).

To only kill challenge containers, see [ckill](#skill). To only kill
solvescript containers, see [skill](#skill)

> [!NOTE]
> This target wraps [ckill](#ckill) and [skill](#skill).

### dist

This target creates a `<name>.tar.gz`-archive of the files contained in the
`dist/` folder. We recommend to commit this file into the CTF repository when
the challenge is finished.

Put everything that the players should get in `dist/`. Our recommendations is
to symlink files from `challenge/` to `dist/` that won't need modification. For
secret files just create a public version under `dist/`.

The `.tar.gz` automatically creates a compressed subfolder `<name>` on the fly,
so decompressing doesn't pollute `${PWD}`

In addition, it also creates a file containing all the checksums from the
original files. When giving support for solvescripts working locally but not
remotely, ask the player to verify the checksums with:

```console
sha256sum -c sha256sum
```

### distrun

Takes an existing `<name>.tar.gz` and uses it to locally deploy the challenge
as a player would do.

Use it in combination with `make solve` to ensure the distributed tarfile is
deployable and solvable.

### version

Prints the type of the makefile in use and the current version-number.

Check for the latest version in [version](#version).

### solve-sequential

Runs [solve](#solve) sequentially for multiple runs.

Supports `TIMES` to select the ammount of runs:

```console
make solve-sequential TIMES=100
```

#### solve-parallel

Runs [solve](#solve) in parallel for multiple runs.

Supports `TIMES` to select the ammount of runs and `JOBS` to select the threads:

```console
make solve-sequential TIMES=100 JOBS=5
```

#### deploy

This target is a wrapper for other deploy targets, can be changed to make it
the default deployment for a CTF. For default, it runs
[deploy-registry](#deploy-registry).

#### deploy-yml

Uses the ctfd-entry-template in `deployment/ctfd-entry.yml.template` and
templates a ctfd-entry that can be imported into CTFd by using a tool like
[ctfdcli](https://github.com/CTFd/ctfcli).

#### deploy-quadlet

Uses `podlet` to convert the the challenge into a quadlet (podman) so the
challenge can be deployed as a systemd service.

#### deploy-docker

Uses `composerize` to convert the challenge into a `docker-compose.yml` file so
the challenge can be deployed as a docker-compose container.

#### deploy-registry

This target pushes the challenge container built by [build](#build) and pushes
it to the registry defined in the `Makefile` (default: `localhost`).

Can be used to push the challenges into a registry and deploy the challenges in
Kubernetes.

Expects the user to be authenticated into the specified registry.

#### clean

Can be customized to clean intermediate files from the challenge. The default
files that cleans is:

* `<name>.tar.gz`
* dist/challenge (depending)
* dist/deploy.sh
* dist/sha256sum 
* solution/challenge
* `ctfd-<name>.yml`
