# Python3.12-Bookworm Container
# Debian Bookworm (Basesystem) with Python3.12 installed 

###############
# Base system #
###############
FROM docker.io/library/python@sha256:18159b2be11db91f84b8f8f655cd860f805dbd9e49a583ddaac8ab39bf4fe1a7

# Install apt dependencies if needed
RUN DEBIAN_FRONTEND=noninteractive apt update \
    && apt install -y curl git \
    && apt clean \
    && python -m pip install pwntools

# Install Foundary
RUN curl -L https://foundry.paradigm.xyz | bash \
    && bash -c "\
        source /root/.bashrc \
        && foundryup \
            --install v1.0.0 \
            --arch amd64" \
    && chmod 755 -R /root

WORKDIR /tmp/solution
COPY foundry.toml .
COPY solve_challenge.py .
COPY sources/ sources/

CMD /usr/bin/timeout -k 5 ${TIMEOUT} python solve_challenge.py \
    --host ${HOST} --port ${PORT} --ticket ${TICKET} ${VERBOSE}
