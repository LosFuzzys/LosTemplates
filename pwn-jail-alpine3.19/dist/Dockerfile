# Alpine 3.19.1 (base system)

##################
# Builder system #
##################
# FROM docker.io/library/alpine@sha256:c5b1261d6d3e43071626931fc004f70149baeba2c8ec672bd4f27761f8e1ad6b as builder
# 
# # Install apt dependencies if needed
# RUN apk update && apk add --no-cache gcc make musl-dev && rm -rf /var/cache/apk/*
# 
# COPY challenge/ /tmp/build/
# RUN make -C /tmp/build/ challenge
# ARG CACHEBUST=1
# CMD cp /tmp/build/challenge /dist/challenge

###############
# Base system #
###############
FROM docker.io/library/alpine@sha256:c5b1261d6d3e43071626931fc004f70149baeba2c8ec672bd4f27761f8e1ad6b as base

# Install apt dependencies if needed
RUN apk update && apk add --no-cache coreutils && rm -rf /var/cache/apk/*

#################
# Runner system #
#################
# Opensuse Tumbleweed (only for running nsjail)
FROM docker.io/opensuse/tumbleweed@sha256:b2daeb56bbe4edcc696af872ed0ad3d2ad0120e3fc0e06c791f16dcb5bed15ad 

# Install apk dependencies if needed
RUN zypper -n install nsjail && zypper -n clean --all

# Copy base filesystem
COPY --from=base / /jail

# Copy challenge required files
RUN mkdir -p /jail/app
# COPY --from=builder /tmp/build/challenge /jail/app/challenge
COPY challenge /jail/app/challenge
RUN chmod +x /jail/app/challenge
COPY flag.txt /jail/flag.txt
COPY entrypoint.sh /jail/app/entrypoint.sh

CMD nsjail --mode l --disable_proc --time_limit ${TIMEOUT} --bindhost 0.0.0.0 --port 1337 --bindmount_ro /jail:/ -m none:/dev:tmpfs:mode=555,size=1,uid=65534,gid=65534 -R /dev/urandom -R /dev/random -B /dev/null -R /dev/zero --cwd /app/ -u 1337:1337:1 -g 1337:1337:1 -u 65534:65534:1 -g 65534:65534:1 -- /app/entrypoint.sh
