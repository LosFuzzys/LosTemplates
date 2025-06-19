# Alpine 3.21.3 (base system)

##################
# Builder system #
##################
FROM docker.io/library/alpine@sha256:a8560b36e8b8210634f77d9f7f9efd7ffa463e380b75e2e74aff4511df3ef88c AS builder

# Install apt dependencies if needed
RUN apk update && apk add --no-cache gcc make musl-dev && rm -rf /var/cache/apk/*

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

#################
# Runner system #
#################
FROM docker.io/library/alpine@sha256:a8560b36e8b8210634f77d9f7f9efd7ffa463e380b75e2e74aff4511df3ef88c

# Install apt dependencies if needed
RUN apk update && apk add --no-cache coreutils socat && rm -rf /var/cache/apk/*

# Copy challenge required files
RUN mkdir -p /app
COPY --from=builder /tmp/build/challenge /app/challenge
RUN chmod +x /app/challenge
COPY flag.txt /flag.txt
COPY entrypoint.sh /app/entrypoint.sh

SHELL ["/bin/sh", "-c"]
CMD socat -T 60 TCP-LISTEN:1337,fork,nodelay,reuseaddr,pktinfo EXEC:"/usr/bin/timeout -k 5 ${TIMEOUT} /app/entrypoint.sh"
