# pwn-qemu-kernel template

## TLDR

- You get an SSH connection to a qemu machine
- You have an unprivileged user shell
- `/flag.txt` is owned by root

Everything runs in qemu, so you can tweak the kernel or add custom modules for
the privilege escalation.

## Buildroot & Kernel

You have to manually precompile them. Building them is too complex for including
it in the template logic.

You have makefiles available that pre-do most of the work.

- The rootfs has to be in `qcow2` format, by default we use buildroot to build it.
- The kernel is taken from `bzImage`. Default is 6.10.2
- A custom module in `challenge/module/module.ko` is loaded at startup

## Before the CTF

### Port range

Increase the range:

```sh
export PUBPORTSTART  = 20000
export PUBPORTEND    = 20035
```

as every port is a seat for a player.

Making it very big doesn't work in docker, as it spawns a process per forwarded
port. Podman allocates it on-request. Kubernetes works.

So for testing, keep the range low. For deployment increase it.

If you have control over the allocated ports in the system (simple VPS with
nothing else running) then you can deploy it with podman (quadlets) with `make
deploy-quadlet` and a very big range

### Proof of Work

Consider adding proof of work (see `addon-proof-of-work`), just call it at the
start of `entrypoint.sh` and exit if non-zero status is returned.
