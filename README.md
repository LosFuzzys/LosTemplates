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

All the template logic is implemented in the `Makefile` at the root of every
template folder. 

You can customize the templates for every challenge as long as:

- `make` targets behave the same way
- `nsjail` (or similar) is not disabled in `--privileged` templates

If you don't want to build the challenge from source and want to include a
precompiled binary, you can. Check the `Dockerfile` in the corresponding
template for that.

`Makefile`'s might contain different targets, but they all inherit a common
interface described in the table below:

**Targets**

| Target             | Description                                                                                                      |
|--------------------|------------------------------------------------------------------------------------------------------------------|
| `all (default)`    |  Runs the challenge locally. Wraps `build` + `run`.                                                              |
| `build`            |  Builds the challenge container.                                                                                 |
| `run`              |  Runs the challenge container.                                                                                   |
| `solve`            |  Solves the challenge (via netcat). Supports `HOST=remote.com` `PORT=9999`                                       |
| `solve-sequential` |  Solves the challenge `TIMES` sequentially. Returns failed runs via `$?`                                         |
| `solve-parallel`   |  Solves the challenge `TIMES` with `JOBS` parallel threads.                                                      |
| `dist`             |  Generates the handout file for the challenge. Upload to CTFd and/or upstream.                                   |
| `distrun`          |  Extracts the handout file and runs the handout challenge.                                                       |
| `test`             |  Checks if the challenge works. Deploy+solve and deploy handout + solve.                                         |
| `lint`             |  Lints mistakes                                                                                                  |
| `kill`             |  Kills all containers related to the challenge                                                                   |
| `clean`            |  Cleans the challenge handout and compiled binaries                                                              |
| `deploy`           |  Deploys the challenge via the default deployment (docker, quadlet, etc.)                                        |
| `deploy-docker`    |  Generates the `docker-compose.yml` file for docker-compose deployment                                           |
| `deploy-quadlet`   |  Generates the systemd quadlet unit for systemd services deployments                                             |
| `deploy-registry`  |  Pushes the challenge container to a OCI registry specified in `REGISTRY`                                        |
| `deploy-yml`       |  Generates the CTFd yaml file for challenge metadata                                                             |
| `shell`            |  Opens a shell in the running challenge container and chroots into the jail root directory in jailed challenges  |
| `version`          |  Prints the current template version                                                                             |

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

## Contribution 

We welcome every contribution to the project. You can check for issues and open
a PR concerning that.
