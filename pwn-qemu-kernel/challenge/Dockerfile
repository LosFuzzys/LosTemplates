# Ubuntu 24.04
# GCC 13.3.0
# Clang 18.1.3
# GLIBC 2.39

##################
# Builder system #
##################

# Building the linux kernel, buildroot and its modules is too complex for doing
# it here. Please build them separatedly and provide them in the challenge/
# folder

#################
# Runner system #
#################
FROM docker.io/library/fedora@sha256:6cd815d862109208adf6040ea13391fe6aeb87a9dc80735c2ab07083fdf5e03a as base

# Install apt dependencies if needed
RUN dnf update -y && dnf install -y socat bash ruby libguestfs-tools openssh-clients qemu-system-x86 && dnf clean -y all

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
