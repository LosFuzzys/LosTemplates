# Ubuntu 24.04
# GCC 13.2.0 (13.2.0-7ubuntu1)
# Clang 18.1.3 (1:18.0-59~exp2)
# GLIBC 2.39 (GLIBC 2.39-0ubuntu8.6)


##################
# Builder system #
##################

# Building the linux kernel, buildroot and its modules is too complex for doing
# it here. Please build them separatedly and provide them in the challenge/
# folder

#################
# Runner system #
#################
FROM docker.io/library/ubuntu:noble-20251013 AS base

ADD --chmod=0755 \
    --checksum=sha256:c125df9762b0c7233459087bb840c0e5dbfc4d9690ee227f1ed8994f4d51d2e0 \
    https://raw.githubusercontent.com/reproducible-containers/repro-sources-list.sh/v0.1.4/repro-sources-list.sh \
    /usr/local/bin/repro-sources-list.sh

RUN repro-sources-list.sh

# Install apt dependencies if needed
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y socat bash ruby libguestfs-tools openssh-client qemu-system-x86 && apt-get clean 

# Copy kernel images & modules
COPY buildroot/rootfs.qcow2 /app/
COPY linux/bzImage /app/
COPY module/module.ko /app/

# Copy flag
COPY flag.txt /app/flag.txt

# Copy helper scripts
COPY helper/entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh
COPY helper/cleaner.sh /app/cleaner.sh
RUN chmod +x /app/cleaner.sh
COPY helper/bootstrap.sh /app/bootstrap.sh
RUN chmod +x /app/bootstrap.sh

USER 1000

SHELL ["/bin/sh", "-c"]
CMD /app/bootstrap.sh 
