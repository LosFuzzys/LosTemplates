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
FROM docker.io/library/ubuntu@sha256:1e622c5f073b4f6bfad6632f2616c7f59ef256e96fe78bf6a595d1dc4376ac02 as base

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

CMD ["/app/bootstrap.sh"]
