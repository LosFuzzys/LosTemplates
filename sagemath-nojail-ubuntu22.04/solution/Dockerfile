# Ubuntu 22.04.4 LTS
# SageMath version 10.3 stable
# Python 3.11.1
FROM docker.io/sagemath/sagemath@sha256:aeefedc716b4f475ddc5f8d8140dbb231868b8a2e5882044845c83d41d1014a5

# Run as root
USER 0

# Install apt dependencies if needed
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y python3 python3-venv coreutils ncurses-bin && apt-get clean

# Install pip dependencies via sage
USER 1000
COPY requirements.txt /app/requirements.txt
RUN sage -pip install --no-cache-dir --upgrade -r /app/requirements.txt 

USER 0
COPY exploit /app/exploit
USER root
RUN chmod 755 /app/exploit
USER 1000

ENV DOT_SAGE=/tmp/

ENV PWNLIB_NOTERM=1
ENV TERM=linux

WORKDIR /app

CMD "/usr/bin/timeout ${TIMEOUT} ./exploit HOST=${HOST} PORT=${PORT}"
