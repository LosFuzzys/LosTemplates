# Ubuntu 24.04
# Rust 1.75 (1.75.0+dfsg0ubuntu1-0ubuntu7.1)
# GCC 13.2.0 (13.2.0-7ubuntu1)
# GLIBC 2.39 (GLIBC 2.39-0ubuntu8.6)

##################
# Builder system #
##################
FROM docker.io/library/ubuntu:noble-20251013 AS builder

ADD --chmod=0755 \
    --checksum=sha256:c125df9762b0c7233459087bb840c0e5dbfc4d9690ee227f1ed8994f4d51d2e0 \
    https://raw.githubusercontent.com/reproducible-containers/repro-sources-list.sh/v0.1.4/repro-sources-list.sh \
    /usr/local/bin/repro-sources-list.sh

RUN repro-sources-list.sh

# Install apt dependencies if needed
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y cargo make gcc && apt-get clean 

COPY . /tmp/build/
RUN make -C /tmp/build/ challenge
# Copy final binary to dist
# CACHEBUST is a Docker trick to invalidate the cache at a exact point
# if not, when docker has cached the compilation it wouldn't output
# the binary to our dist/ directory so we can pack it for distribution
ARG CACHEBUST=1
SHELL ["/bin/sh", "-c"]
CMD cp /tmp/build/challenge /dist/challenge

#################
# Runner system #
#################
FROM docker.io/library/ubuntu:noble-20251013

ADD --chmod=0755 \
    --checksum=sha256:c125df9762b0c7233459087bb840c0e5dbfc4d9690ee227f1ed8994f4d51d2e0 \
    https://raw.githubusercontent.com/reproducible-containers/repro-sources-list.sh/v0.1.4/repro-sources-list.sh \
    /usr/local/bin/repro-sources-list.sh

RUN repro-sources-list.sh

# Install apt dependencies if needed
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y socat coreutils && apt-get clean 

# Copy challenge required files
RUN mkdir -p /app
COPY --from=builder /tmp/build/challenge /app/challenge
RUN chmod +x /app/challenge
COPY flag.txt /flag.txt
COPY entrypoint.sh /app/entrypoint.sh

SHELL ["/bin/sh", "-c"]
CMD socat -T 60 TCP-LISTEN:1337,fork,nodelay,reuseaddr,pktinfo EXEC:"/usr/bin/timeout -k 5 ${TIMEOUT} /app/entrypoint.sh"
