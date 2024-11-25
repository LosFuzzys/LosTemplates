#!/bin/sh
. /home/sage/.venv/bin/activate 2>&1 >/dev/null
export PATH="/home/sage/.venv/bin:$PATH"
/usr/bin/stdbuf -i0 -o0 -e0 sage /app/challenge
