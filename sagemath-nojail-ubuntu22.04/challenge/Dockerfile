# Ubuntu 22.04.5 LTS
# SageMath version 10.6 stable
# Python 3.12.5

###############
# Base system #
###############
FROM docker.io/sagemath/sagemath@sha256:19995db6194f4a4bab18ce9a88556fd15b9ed5e916b4504fefe618a7796ddbdb

# Run as root
USER 0

# Install apt dependencies if needed
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y python3 python3-venv socat coreutils && apt-get clean

# Enable the virtual enviroment
USER 1000
RUN sage --python3 -m venv /home/sage/.venv
ENV PATH="/home/sage/.venv/bin:$PATH"

# Install pip dependencies
COPY requirements.txt /app/requirements.txt
RUN sage -pip install --no-cache-dir --upgrade -r /app/requirements.txt 

# Copy challenge required files
USER 0
RUN mkdir -p /app
COPY challenge /app/challenge
RUN chmod +x /app/challenge
COPY flag.txt /flag.txt
COPY entrypoint.sh /app/entrypoint.sh

# Run as sage user
USER 1000

ENV PWNLIB_NOTERM=1
ENV DOT_SAGE=/tmp/

# Quoting is required in this template
CMD "socat -T 60 TCP-LISTEN:1337,fork,nodelay,reuseaddr,pktinfo EXEC:\"/usr/bin/timeout -k 5 ${TIMEOUT} /app/entrypoint.sh\""
