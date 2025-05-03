# Ubuntu 24.04
# Rust 1.75
# GCC 13.3.0
# GLIBC 2.39

##################
# Builder system #
##################
FROM docker.io/library/ubuntu@sha256:1e622c5f073b4f6bfad6632f2616c7f59ef256e96fe78bf6a595d1dc4376ac02 AS builder

# Install apt dependencies if needed
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y cargo make gcc && apt-get clean 

COPY . /tmp/build/
RUN make -C /tmp/build/ challenge
# Copy final binary to dist
# CACHEBUST is a Docker trick to invalidate the cache at a exact point
# if not, when docker has cached the compilation it wouldn't output
# the binary to our dist/ directory so we can pack it for distribution
ARG CACHEBUST=1
CMD cp /tmp/build/challenge /dist/challenge

#################
# Runner system #
#################
FROM docker.io/library/ubuntu@sha256:1e622c5f073b4f6bfad6632f2616c7f59ef256e96fe78bf6a595d1dc4376ac02

# Install apt dependencies if needed
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y socat coreutils && apt-get clean 

# Copy challenge required files
RUN mkdir -p /app
COPY --from=builder /tmp/build/challenge /app/challenge
RUN chmod +x /app/challenge
COPY flag.txt /flag.txt
COPY entrypoint.sh /app/entrypoint.sh

CMD socat -T 60 TCP-LISTEN:1337,fork,nodelay,reuseaddr,pktinfo EXEC:"/usr/bin/timeout -k 5 ${TIMEOUT} /app/entrypoint.sh"
