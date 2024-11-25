# Template Guidelines

Install `docker`, `make`, GNU `tar`, GNU `coreutils` and `parallel`.

All templates have been tested on Fedora 40 and default Ubuntu 24.04 with podman and docker.

## Usage TLDR

- `make` will deploy the challenge locally on `0.0.0.0:1337` with 30 seconds of timeout
- `make solve` will solve the challenge on `0.0.0.0:1337` (parallel options available)
- `make dist` will generate the distribution `.tar.gz`
- `make distrun` will deploy the challenge using the `.tar.gz` (simulating a player)

All targets accept `HOST`, `PORT`, `TIMEOUT` to configure the challenge: `make solve HOST=glacierctf.com PORT=8888`,
`make TIMEOUT=0`, etc.

## Contributor TLDR

Feel free to modify anything you don't like from the templates, but keep their
"interface" compatible (see Usage TLDR).

- Folder name will be challenge name (slugified)
- Modify `Makefile` and edit the top variables as you wish
- The default target in `challenge/Makefile` will be run to build your challenge
- By default, the binary should be named `challenge` but you can change it (you'll have to patch some paths in the scripts)
- Symlink/copy anything you want distributed in `dist/`
- Everything in `dist/` will end up in the `.tar.gz` with a SHA256 hash sum
- You can establish additional nsjail resource limits if your challenge needs them
- You shouldn't weaken nsjail protections as the runner container has to be privileged
