# - Ubuntu 22.04.4 LTS
# - pwntools v4.12.0 stable
# - Python 3.10.12
# - GLIBC 2.35-0ubuntu3.6
FROM docker.io/pwntools/pwntools@sha256:1707bef16a3fb924d53231d899eeecaf18b5ebbb78e23c38d41dcd19d147bf6b

# Install apt dependencies if needed
# USER root
# RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y ... && apt-get clean
# USER pwntools

WORKDIR /app
COPY requirements.txt .

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
RUN uv pip sync /app/requirements.txt

# Copy needed files to /app
COPY exploit .
USER root
RUN chmod 755 /app/exploit
USER pwntools

ENV PWNLIB_NOTERM=1

CMD /usr/bin/timeout -k 5 ${TIMEOUT} ./exploit REMOTE HOST=${HOST} PORT=${PORT}
