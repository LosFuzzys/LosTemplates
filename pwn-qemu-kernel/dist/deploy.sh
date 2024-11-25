#!/bin/sh

check() {
  echo -e "\e[1;34m[+] Verifying Challenge Integrity\e[0m"
  sha256sum -c sha256sum
}

build_container() {
  echo -e "\e[1;34m[+] Building Challenge Docker Container\e[0m"
  docker build -t localhost/chall-pwn-qemu-kernel --platform linux/amd64 . 
}

run_container() {
  echo -e "\e[1;34m[+] Running Challenge Docker Container on 127.0.0.1:1337\e[0m"
  docker run --name chall-pwn-qemu-kernel --rm -p 127.0.0.1:1337:1337 -t -i -e HOST=127.0.0.1 -e PORT=1337 -e TIMEOUT=30 -e PUBPORTSTART=20000 -e DOMAIN=127.0.0.1 -e PUBPORTEND=30000 -p 127.0.0.1:20000-30000:20000-30000 --user 1337:1337 --read-only --privileged --platform linux/amd64 localhost/chall-pwn-qemu-kernel
}

kill_container() {
	docker ps --filter "name=chall-pwn-qemu-kernel" --format "{{.ID}}" \
		| tr '\n' ' ' \
		| xargs docker stop -t 0 \
		|| true
}

case "${1}" in
  "check")
    check
    ;;
  "build")
    build_container
    ;;
  "run")
    run_container
    ;;
  "kill")
    kill_container
    ;;
  *)
    check
    build_container
    run_container
    ;;
esac
