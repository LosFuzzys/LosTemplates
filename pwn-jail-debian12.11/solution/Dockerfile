# Debian Bookworm 12.11 (30.07.2025)
FROM docker.io/library/debian:stable@sha256:de77ae1b03425c79cd5c829687b3db9f1c62e25af09b34aed09f684043f0285a
COPY --from=ghcr.io/astral-sh/uv:0.7.2 /uv /uvx /bin/

# Install apt dependencies if needed
# RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y ... && apt-get clean

WORKDIR /app
COPY pyproject.toml requirements.txt* uv.lock* .python-version* ./

# Install python dependencies
ENV UV_COMPILE_BYTECODE=1
ENV UV_CACHE_DIR=/root/.cache/uv/
# If author uses requirements.txt, respect it and port it to uv (not recommended)
RUN [ -s "requirements.txt" ] && (uv add --link-mode=copy -r requirements.txt && \
  echo "\e[1;33m--> Consider porting requirements.txt to pyproject.toml with: uv add -r requirements.txt && rm requirements.txt\e[0m") \
  || true
# Install uv dependencies and respect the lockfile
RUN uv sync --locked --compile-bytecode --link-mode=copy && uv tree --locked && uv python list --only-installed

# Copy exploit(s) /app
COPY exploit .
RUN chmod 755 /app/exploit

# Copy challenge relevant files
COPY challenge .

ENV PWNLIB_NOTERM=1 PYTHONUNBUFFERED=1 UV_COMPILE_BYTECODE=0 UV_OFFLINE=1 UV_LOCKED=1

SHELL ["/bin/sh", "-c"]
CMD /usr/bin/timeout --foreground -k 5 ${TIMEOUT} ./exploit REMOTE HOST=${HOST} PORT=${PORT}
