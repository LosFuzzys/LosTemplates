# Debian Bookworm 12.11 (30.07.2025)
# GCC 12.2.0 (Debian 12.2.0-14+deb12u1)
# Clang 14.0.6 (Debian)
# GLIBC 2.36 (Debian GLIBC 2.36-9+deb12u10)

##################
# Builder system #
##################
FROM docker.io/library/debian:stable@sha256:de77ae1b03425c79cd5c829687b3db9f1c62e25af09b34aed09f684043f0285a AS builder

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
FROM docker.io/library/debian:stable@sha256:de77ae1b03425c79cd5c829687b3db9f1c62e25af09b34aed09f684043f0285a AS base

# Install apt dependencies if needed
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y coreutils && apt-get clean

#################
# Runner system #
#################
# Opensuse Tumbleweed (only for running nsjail)
FROM docker.io/opensuse/tumbleweed@sha256:f4df2009eaccba59437997c2545ba2d6fc731dcda892aa57aec6dc101d7a1f9f

# Install apk dependencies if needed
RUN zypper -n install nsjail && zypper -n clean --all

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
