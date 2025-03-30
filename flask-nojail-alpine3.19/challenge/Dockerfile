# Alpine 3.19.1 (base system)

###############
# Base system #
###############
FROM docker.io/library/alpine@sha256:e5d0aea7f7d2954678a9a6269ca2d06e06591881161961ea59e974dff3f12377

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
COPY entrypoint.sh /app
COPY flag.txt /flag.txt
COPY src/ /app
RUN chmod +x /app/app.py

CMD /app/entrypoint.sh
