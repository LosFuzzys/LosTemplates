# Ubuntu 24.04

###############
# Base system #
###############
FROM docker.io/library/ubuntu@sha256:1e622c5f073b4f6bfad6632f2616c7f59ef256e96fe78bf6a595d1dc4376ac02 AS base

# Install apt dependencies if needed
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y socat coreutils && apt-get clean

#################
# Runner system #
#################
# pinned to alpine 3.23.5, with nsjail 3.6, fakeroot 1.37.2
FROM docker.io/library/alpine@sha256:fd791d74b68913cbb027c6546007b3f0d3bc45125f797758156952bc2d6daf40

# Install apk dependencies if needed
RUN apk update && apk add nsjail fakeroot && apk cache clean

# Copy base filesystem
COPY --from=base / /jail

# Copy challenge required files
RUN mkdir -p /jail/app
COPY challenge /jail/app/challenge
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
