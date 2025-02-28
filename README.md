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
This target builds the image of the challenge as specified by the Dockefile.
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
This target builds the Dockerimage in `/solution/Dockerfile` (using [sbuild](#sbuild)) and runs the previously build Dockerimage (using [srun](#srun)).
Depending on the template, the usage of this target varies:
* If the challenge does not have a remote instance (e.g. for the *offlie*-template), then `solve` can be run without running `run`.
* If the challenges does depend on a remote instance, the author has to start it by running the `run`-target in another terminal or in the background.


> [!NOTE]
> This target wraps [sbuild](#sbuild) and [srun](#srun).

### kill
This target stops all containers providing the challenge (usually only one) and all containers running the solve-scripts (in case [srun-parallel](-srun-parallel) has been used, there might be more then one instance).
Challenge-containers are being stopped at first, afterwards all solve-containers are being stopped.

> [!NOTE]
> This target wraps [ckill](#ckill) and [skill](#skill).

### dist
This target creates a `<name>.tar.gz`-archive of the files in the dist-folder.
In addition, it also creates a file containing all the checksums.
This checksum-file can be used by the user to determine if he changed some files (mainly important for *pwn*-challenges).

The file is creates such that `<name>` is the name of the folder that the Makefile is in.

### Other targets

#### cbuild
This target builds the image as specified by the `Dockerfile` and tags it as `localhost/<name>` where `<name>` is the name of the folder that the Makefile is in.

Depending on the template, this might be done in multiple stages.
For example, in the `pwn-jail-ubuntu24.04`-template the following steps are done:
1) At first the `builder`-image is being created as `localhost/<name>-build`.
2) This image is then being used to build the challenge, in case of this template it would be the *pwn*-binary
3) Afterwards, the final container is being built

#### crun
This target uses the image built in [cbuild](#cbuild) as image for a container.
The container is run such that the challenge is available on host and port as specified in the deployment-section of the makefile.
The default for the host is `127.0.0.1` and `1337` for the port.

#### ckill
This target **stops** the challenge-container previously started using [crun](#crun).

#### sbuild
This target builds the image in `solution/Dockerfile` and tags it as `localhost/<name>-solvescript` where `<name>` is the name of the folder that the Makefile is in.

#### srun
This target uses the image built in [sbuild](#sbuild) as image for a solve-container.
To connect to the challenge-container, it uses the host and port as specified in the deployment-section of the makefile.

#### srun-sequential
This target behaves similar to [srun](#srun) but runs the solve-container multiple times sequentially.
The number of executions can be changed by changing the `TIMES`-variable.

#### srun-parallel
This target behaves similar to [srun](#srun) but runs the solve-container multiple times in parallel.
The number of executions can be changed by changing the `TIMES`-variable, the number of containers being run in parallel by changing the `JOBS`-variable.

#### skill
This target **stops** the solve-container(s) previously started using [srun](#srun), [srun-sequential](#srun-sequential) or [srun-parallel](#srun-parallel).

#### distrun
This target places all files in the `<name>.tar.gz`-file generated by [dist](#dist) into the solutions-folder.
This is done so that the author can check that the challenge is solvable using the files provided to the participants.
That is mostly done after before the event to make sure that the challenge did not break during the development- & review-process.

#### deploy
This target is a wrapper for [deploy-registry](#deploy-registry).

#### deploy-yml
This target uses the ctfd-entry-template in `deployment/ctfd-entry.yml.template` and templates a ctfd-entry that can be imported into CTFd by using a tool like [ctfdcli](https://github.com/CTFd/ctfcli).

#### deploy-quadlet
This target uses the systemd-service.container.template in `deployment/systemd-service.container.template` in order to generate a configuration that allows this challenge being started and stopped using systemd on systems that have podman-quadlet installed.

#### deploy-docker
This target uses `composerize` in order to create a docker-compose file from a docker-run command.
The docker-compose file is being stored in `deployment/docker-compose.yml`.

#### deploy-registry
This target pushes the challenge-container built by [cbuild](#cbuild) and pushes it to the registry defined in the deployment-configuration.
Depending on the registry, the user might need to sign in, the templates does not cover this (it expects the user to be signed in and able to push to the specified registry)

#### clean
This target removes the following files:
* `<name>.tar.gz`
* dist/challenge
* dist/deploy.sh
* dist/sha256sum 
* solution/challenge
* `ctfd-<name>.yml`

Apart of `dist/challenge` and `solution/challenge` all of these files are files generated by individual make-targets.
