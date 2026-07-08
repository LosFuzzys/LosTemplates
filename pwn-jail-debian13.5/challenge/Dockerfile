# Debian Bookworm 13.5 (13.05.2026)
# GCC 14.2.0 (Debian 14.2.0-19)
# Clang 19.1.7 (Debian)
# GLIBC 2.41 (Debian GLIBC 2.41-12+deb13u3)

##################
# Builder system #
##################
FROM docker.io/library/debian:stable@sha256:d07d1b51c39f51188e60be9b64e6bf769fa94e187f092bc32b91305cfa34ba5a AS builder

# Install apt dependencies if needed
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y make gcc clang && apt-get clean 

# NOTE: If you want to use a precompiled binary, uncomment
# comment the build binary section and uncomment the use
# precompiled binary section

### Build Binary
COPY . /tmp/build/
RUN make -C /tmp/build/ challenge
ARG CACHEBUST=1
SHELL ["/bin/sh", "-c"]
CMD cp /tmp/build/challenge /dist/challenge

### Use precompiled binary 
# COPY ./challenge /tmp/build/challenge
# COPY ./challenge /dist/challenge

###############
# Base system #
###############
FROM docker.io/library/debian:stable@sha256:d07d1b51c39f51188e60be9b64e6bf769fa94e187f092bc32b91305cfa34ba5a AS base

# Install apt dependencies if needed
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y coreutils && apt-get clean

#################
# Runner system #
#################
# Opensuse Tumbleweed (only for running nsjail)
FROM docker.io/opensuse/tumbleweed@sha256:a029741b691d98438bd078f6e819812b0665d1be773966951488827a85ab956e

# Install apk dependencies if needed
RUN zypper -n install -y git make autoconf libtool flex bison pkg-config gcc-c++ protobuf-devel libnl3-devel && \
    git clone --depth 1 --branch 3.6 --recurse-submodules https://github.com/google/nsjail /tmp/nsjail && \
    make -C /tmp/nsjail -j"$(nproc)" && \
    install -m0755 /tmp/nsjail/nsjail /usr/bin/nsjail && \
    rm -rf /tmp/nsjail && \
    zypper -n clean --all

# Copy base filesystem
COPY --from=base / /jail

# Copy challenge required files
RUN mkdir -p /jail/app
COPY --from=builder /tmp/build/challenge /jail/app/challenge
RUN chmod +x /jail/app/challenge
COPY flag.txt /jail/flag.txt
COPY entrypoint.sh /jail/app/entrypoint.sh

# add "-m none:/DESTPATH:tmpfs:size=N" before --cwd on nsjail args to have a tmpfs-backed writable DESTPATH of N bytes
# remember that /DESTPATH cannot contain any files coming from /jail (as its a mount). If you want 
# pre-created/copied files in /DESTPATH you should manually copy them in entrypoint.sh
# Note: /DESTPATH should not contain /jail as a prefix

SHELL ["/bin/sh", "-c"]
CMD nsjail \
    --mode l \
    --disable_proc \
    --time_limit ${TIMEOUT} \
    --bindhost 0.0.0.0 \
    --port 1337 \
    --bindmount_ro /jail:/ \
    -m none:/dev:tmpfs:mode=555,size=1,uid=65534,gid=65534 \
    -R /dev/urandom \
    -R /dev/random \
    -B /dev/null \
    -R /dev/zero \
    --cwd /app/ \
    -u 1337:1337:1 \
    -g 1337:1337:1 \
    -u 65534:65534:1 \
    -g 65534:65534:1 \ 
    -- /app/entrypoint.sh
