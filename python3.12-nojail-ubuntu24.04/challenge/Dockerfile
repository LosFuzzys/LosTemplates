# Ubuntu 24.04

###############
# Base system #
###############
FROM docker.io/library/ubuntu@sha256:1e622c5f073b4f6bfad6632f2616c7f59ef256e96fe78bf6a595d1dc4376ac02 AS builder

# Install apt dependencies if needed
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y python3 python3-venv socat coreutils && apt-get clean

# Enable the virtual enviroment
RUN python3 -m venv /.venv
ENV PATH="/.venv/bin:$PATH"

# Install pip dependencies
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt 

# Copy challenge required files
RUN mkdir -p /app
COPY challenge /app/challenge
RUN chmod +x /app/challenge
COPY flag.txt /flag.txt
COPY entrypoint.sh /app/entrypoint.sh

CMD socat -T 60 TCP-LISTEN:1337,fork,nodelay,reuseaddr,pktinfo EXEC:"/usr/bin/timeout -k 5 ${TIMEOUT} /app/entrypoint.sh"
