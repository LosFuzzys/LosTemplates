#!/bin/sh

# This should be the correct thing to do but it doesn't work
# . /home/sage/.venv/bin/activate 2>&1 >/dev/null
# export PATH="/home/sage/.venv/bin:$PATH"

/usr/bin/stdbuf -i0 -o0 -e0 sage /app/challenge
