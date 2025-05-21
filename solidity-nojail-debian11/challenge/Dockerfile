# Python 3.9.22 with Debian Bullseye (base system)

###############
# Base system #
###############
FROM docker.io/library/python@sha256:460af7209c9559d38047928f6ab66312e5274e42ef7f502eed624ff5ae8a15be

# environment variables used in 00-create-xinetd-service
ENV PORT=31337
ENV CPS_RATE=200
ENV PER_SOURCE=5000
ENV CPS_DELAY=5
ENV RLIMIT_CPU=5

# environment variables for gunicorn
ENV GUNICORN_HTTP_PORT=8545
ENV GUNICORN_WORKER=16
ENV GUNICORN_THREADS=32
ENV PYTHONPATH /usr/lib/python

# environment variables for the smart contract
ENV CHALLENGE_MIN_ETHER=100
ENV CHALLENGE_FLAG_PATH="/flag.txt"

# Create all necessary folder, install xinitd and tini and create the ctf user
RUN mkdir /var/log/ctf /startup \
    && apt update \
    && apt install -y xinetd tini \
    && rm -rf /var/cache/apt/archives \
    && useradd -m ctf

# Copy files needed for the startup
COPY docker_sources/00-create-xinetd-service /startup
COPY docker_sources/99-start-xinetd /startup
COPY docker_sources/98-start-gunicorn /startup

# Copy other nessesary files/scripts
COPY docker_sources/handler.sh /home/ctf/handler.sh
COPY docker_sources/entrypoint.sh /entrypoint.sh
COPY docker_sources/eth_sandbox /usr/lib/python/eth_sandbox
COPY docker_sources/requirements.txt /root
COPY docker_sources/init_blockchain.py /home/ctf/init_blockchain.py

RUN python3 -m pip install -r /root/requirements.txt 


# Install Foundary
RUN curl -L https://foundry.paradigm.xyz | bash \
    && bash -c "\
        source /root/.bashrc \
        && foundryup \
            --install v1.0.0 \
            --arch amd64" \
    && chmod 755 -R /root

# Copy all challange files
RUN mkdir /tmp/contracts/
COPY ./*.sol /tmp/contracts/
COPY flag.txt /flag.txt

# CACHEBUST is a Docker trick to invalidate the cache at a exact point
# We are doing this here, in order to cleanly recompile the smart contract
ARG CACHEBUST=1

# Compile the contract and clean up bild artifacts
RUN cd /tmp/ \
    && /root/.foundry/bin/forge build --out /home/ctf/compiled \
    && rm -rf /tmp/contracts

ENTRYPOINT ["tini", "-g", "--"]
CMD ["[/entrypoint.sh]"]
