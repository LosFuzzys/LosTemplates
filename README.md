# LosTemplates - CTF Challenge Templates

Preconfigured CTF challenge templates with sane defaults and an homogeneous
interface. Instanced web, instanced qemu+ssh, jailed pwn, sagemath, and much
more.

No heavy dependencies, no precompiled binaries, no sketchy registries. Just
coreutils, containers, shells and makefiles. Easily auditable, verifiable and
extendable, both for authors and players.

Automatically handle deployments with registry (kubernetes), compose (docker)
or systemd services (quadlets). Generate distribution files, local player
deployments, and CTFd metadata yaml files automatically with no extra effort.

Harmonized interface for all challenges. Run `make` to run, `make solve` to
solve, and other targets: `dist`,`test`,`lint`,`deploy`, etc. Configurable via
arguments: `make PORT=8080`, `make solve HOST=chall.losfuzzys.net`, and more.
Different deployments? `source .env-release`. Keep it simple.

Multiple alternatives, fast actions. Kubernetes cluster down? Cloud rate
limits? Quickly ssh into a VPS and run `make deploy-docker`. Problems? Run
`make HOST=0.0.0.0`. Your infrastructure team will have an easier time.

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

You can check for the latest versions within a script [here](https://raw.githubusercontent.com/LosFuzzys/LosTemplates/refs/heads/main/.versions)

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
# Fedora 42
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

For Linux: `docker`.

For Windows: `docker` (WSL2 backend) and `tar` support.

## Guidelines

All the template logic is implemented in the `Makefile` at the root of every
template folder. This `Makefile` holds metadata configuration that authors can
change. The name of the challenge will be the name of the folder holding the
`Makefile` (by default).

Files in `challenge/` hold the main challenge logic. `challenge/flag.txt`
contains the flag. `challenge/Dockerfile` runs the challenge container and
`challenge/entrypoint.sh` contains the entrypoint of the container. For
challenges with a build step, `challenge/Makefile` is run to build the
challenge.

Files in `dist/` will be packaged for the `.tar.gz` distributed file. Use
symlinks if the file should stay the same, and make a copy with modifications
if you need to redact or change parts of the file. See, for example, how
`dist/flag.txt` is not a symlink. Symlinks will be resolved before packaging. 

Files in `solution/` holds the solvescript and writeup for the challenge.
Dependencies for `solution/exploit` can be added via `uv` in
`solution/requirements.txt` or `apt install` in `solution/Dockerfile`.

Files in `deployment/` contains helper files for the deployment of the
challenge. Organizers can place files here and use them from `Makefile` for
deployments. Ex: shared testing VPS private SSH keys.

**Targets**

| Target             | Description                                                                                                       |
|--------------------|-------------------------------------------------------------------------------------------------------------------|
| `all (default)`    |  Runs the challenge locally. Wraps `build` + `run`.                                                               |
| `build`            |  Builds the challenge container.                                                                                  |
| `run`              |  Runs the challenge container.                                                                                    |
| `solve`            |  Solves the challenge (via netcat). Supports `HOST=remote.com` `PORT=9999`                                        |
| `solve-sequential` |  Solves the challenge `TIMES` sequentially. Returns failed runs via `$?`                                          |
| `solve-parallel`   |  Solves the challenge `TIMES` with `JOBS` parallel threads.                                                       |
| `dist`             |  Generates the handout file for the challenge. Upload to CTFd and/or upstream.                                    |
| `distrun`          |  Extracts the handout file and runs the handout challenge.                                                        |
| `test`             |  Checks if the challenge works. Deploy+solve and deploy handout + solve.                                          |
| `lint`             |  Lints common mistakes (resolved symlinks, missing files, same flags, etc.)º                                      |
| `kill`             |  Kills all containers related to the challenge                                                                    |
| `clean`            |  Cleans the challenge handout and compiled binaries                                                               |
| `deploy`           |  Deploys the challenge via the default deployment (docker, quadlet, etc.)                                         |
| `deploy-docker`    |  Generates the `docker-compose.yml` file for docker-compose deployment                                            |
| `deploy-quadlet`   |  Generates the systemd quadlet unit for systemd services deployments                                              |
| `deploy-registry`  |  Pushes the challenge container to a OCI registry specified in `REGISTRY`                                         |
| `deploy-yml`       |  Generates the CTFd yaml file for challenge metadata                                                              |
| `shell`            |  Opens a shell in the running challenge container (and chroots into the jail root directory in jailed challenges) |
| `version`          |  Prints the current template version                                                                              |

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

### Development Recommendations

**Modifying the Makefile:**

Authors or organizers can edit this `Makefile` in order to add required
functionality for their CTF, in this case we recommend changing the version
label with `-GLACIERCTF`. This way you can compare against it in your automated
testing scripts, it in case it requires non-standard handling.

**Buffering for pwn:**

We don't recommend disabling the buffering at the entrypoint for C programs, it
usually `LD_PRELOAD`s the binary and causes unexpected allocations, possibly
breaking locally developed heap exploits. Always disable it in the program
`main` or init function with `man 3 setvbuf`.

**Creating a writeable path:**

For jailed apps you can create a writeable path with `nsjail`, see
`*-jail-*/challenge/Dockerfile`:

```
# add "-m none:/DESTPATH:tmpfs:size=N" before --cwd on nsjail args to have a tmpfs-backed writable DESTPATH of N bytes
# remember that /DESTPATH cannot contain any files coming from /jail (as its a mount). If you want 
# pre-created/copied files in /DESTPATH you should manually copy them in entrypoint.sh
# Note: /DESTPATH should not contain /jail as a prefix
```

### Deployment Recommendations

**Default deployment:**

Adjust the default deployment target to the inteded one. You can also change it
to deploy to a testing instance and place authentication credentials in
`deployment/` (in case team is trusted).

**Flag:**

Change the flag format in `challenge/flag.txt`, `dist/flag.txt` and
`solution/exploit`. You can write a sed script that does it, in case you want
to pull changes from upstream.

## Contributing

We welcome every contribution to the project. You can check for issues and open
a PR. Feel free to implement new features, but we recommend opening an issue
for discussion before implementing it :)

## FAQ

**Why not an nsjail config:**

This way we can easily control it via enviroment variables if needed, also, the
less infrastructure-related files in `challenge/`, the better for players that
don't care about them. You need to change something about the "runtime" system?
Must be in `challenge/Dockerfile`! You need to change the entrypoint? Must be
`challenge/entrypoint.sh`! This makes it easier for authors that don't know
what `nsjail` is.

## Security

Found a missconfiguration/vulnerability in the templates and want to report it
privately? Send an email to `team@losfuzzys.net`
