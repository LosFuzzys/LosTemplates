# Alpine 3.21.3 (base system)
# Python 3.12

###############
# Base system #
###############
FROM docker.io/library/alpine@sha256:a8560b36e8b8210634f77d9f7f9efd7ffa463e380b75e2e74aff4511df3ef88c

# Install apt dependencies if needed
RUN apk update && apk add --no-cache socat python3 py3-pip coreutils && rm -rf /var/cache/apk/*

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

CMD ["socat", "-T", "60", "TCP-LISTEN:1337,fork,nodelay,reuseaddr,pktinfo", "EXEC:/usr/bin/timeout -k 5 ${TIMEOUT} /app/entrypoint.sh"]
