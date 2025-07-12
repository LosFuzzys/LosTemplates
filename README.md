# LosTemplates - CTF Challenge Templates

Preconfigured CTF challenge templates with sane defaults and an homogeneous
interface. Instanced flask, instanced qemu+ssh, jailed pwn, sagemath, solidity,
and much more.

No heavy dependencies, no precompiled binaries. Just coreutils,
containers, shells and makefiles. Easily auditable, verifiable and extendable,
both for authors and players.

Automatically handle deployments with registry (kubernetes), compose (docker)
or systemd services (quadlets). Generate distribution files, local player
deployments, and CTFd metadata yaml files automatically with no extra effort.

Harmonized interface for all challenges. Run make to launch, make solve to
solve, along with other targets: `dist`,`test`,`lint`,`deploy`,`shell`,`kill`,
.... All configurable via arguments such as `make PORT=8080`, `make solve
HOST=chall.losfuzzys.net`, and much more `RUNTIME`,`TIMEOUT`,.... Different
deployments? `source .env`. Keep it simple.

Powered by [LosFuzzys](https://losfuzzys.net).

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

### Challenge Author

Install `docker`, `bash`, `make`, GNU `envsubst`, GNU/BSD `tar`, GNU `coreutils`
and `parallel`.

**Ubuntu**:
```sh
# Ubuntu 24.04
sudo apt install bash make gettext tar coreutils parallel
# Install podman or docker at your choice
sudo apt install podman podman-docker
```

**Fedora**:
```sh
# Fedora 41
sudo dnf install bash make gettext-envsubst tar coreutils parallel
# Install podman or docker at your choice
sudo dnf install podman podman-docker
```

**Arch**:
```sh
sudo pacman -S bash make gettext tar coreutils parallel
# Install podman or docker at your choice
sudo pacman -S docker
# If you prefer rootless docker, install it from AUR
# but check for the configuration in the wiki
yay docker-rootless-extras
```

**Nix**:

```sh
nix develop
```

### Players

For Linux: `docker`, `tar` and a linux shell.

For Windows: `docker` (WSL2 backend) and `tar`.

## Template Targets and Arguments

**Targets**

| Target             | Description                                                                                  |
|--------------------|----------------------------------------------------------------------------------------------|
| `all (default)`    |  Runs the challenge locally. Wraps `build` + `run`.                                          |
| `build`            |  Builds the challenge container.                                                             |
| `run`              |  Runs the challenge container.                                                               |
| `solve`            |  Solves the challenge (via netcat). Supports `HOST=remote.com` `PORT=9999`                   |
| `solve-sequential` |  Solves the challenge `TIMES` sequentially. Returns failed runs via `$?`                     |
| `solve-parallel`   |  Solves the challenge `TIMES` with `JOBS` parallel threads.                                  |
| `dist`             |  Generates the student handout file for the challenge. Upload to CTFd and/or upstream.       |
| `test`             |  Checks if the challenge works. Deploy+solve and deploy as student + solve.                  |
| `lint`             |  Lints mistakes                                                                              |
| `kill`             |  Kills all containers related to the challenge                                               |
| `deploy`           |  Deploys the challenge via the default deployment (docker, quadlet, etc.)                    |
| `deploy-docker`    |  Generates the `docker-compose.yml` file for docker-compose deployment                       |
| `deploy-quadlet`   |  Generates the systemd quadlet unit for systemd services deployments                         |
| `deploy-registry`  |  Pushes the challenge container to a OCI registry specified in `REGISTRY`                    |
| `deploy-yml`       |  Generates the CTFd yaml file for challenge metadata                                         |
| `shell`            |  Opens a shell in the running challenge container and chroots into the jail root directory.  |

**Arguments**

| Argument            | Description                                                                                  |
|---------------------|----------------------------------------------------------------------------------------------|
| `RUNTIME`           |  Selects the container runtime, i.e: `docker`, `podman`, `sudo docker`, etc.                 |
| `RUNTIME_DIST`      |  Selects the container runtime for the student distribution files, i.e: `docker`.            |
| `HOST`              |  For deployments, IP to listen on. For solutions, challenge IP or domain (local or remote).  |
| `PORT`              |  For deployments, port to listen on. For solutions, challenge port to connect.               |
| `TIMEOUT`           |  For deployments, timeout for challenge kill. For solutions, maximum time to solve.          |
| `TIMES`             |  Number of times to solve the challenge in `solve-sequential` and `solve-parallel`.          |
| `JOBS`              |  Number of parallel threads in `solve-parallel`.                                             |
| `PULL_POLICY_RUN`   |  Pull policy for `docker run`.                                                               |
| `PULL_POLICY_BUILD` |  Pull policy for `docker build`.                                                             |

Arguments can be used as:

```
$ make PORT=8080
$ make solve HOST=challenges.ssdvps.com PORT=8080
$ make deploy-docker PORT=10001
$ make solve-parallel TIMES=100 JOBS=10
$ make RUNTIME='sudo docker'
```

## Usage

All the template logic is implemented in the `Makefile` at the root of every
template folder. Every `Makefile` contains different targets, the most
importants being:

* all (default)
* solve
* dist
* distrun
* lint
* test

Other targets might be helpful too:

* build
* run
* solve-sequential
* solve-parallel
* kill
* clean
* deploy
* version
* shell

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

### lint

Sanity checks the challenge using predefined rules. 

### test

Tests the regular and distributed challenge using `make solve`. The workflow is:
1. `make all`: Spawning the challenge
2. `make solve`: Solves the challenge 
3. `make distrun`: Spawns the distributed challenge 
4. `make solve`: Solves the distributed challenge

If the regular and distributed challenge are solvable, `make test` succeeds,
otherwise it will return with a non-zero value.

### version

Prints the type of the makefile in use and the current version-number.

Check for the latest version in [version](#version).

### shell

Spawns an interactive shell for a running challenge. For jailed challenges
we will `chroot` you into `/jail`. 

> [!NOTE]
> This target requires an running challenge e.g. `make run`.

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
