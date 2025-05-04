#!/bin/sh
. /.venv/bin/activate 2>&1 >/dev/null
export PATH="/.venv/bin:$PATH"
export FLAG=$(cat /flag.txt)
/usr/bin/stdbuf -i0 -o0 -e0 /app/app.py
