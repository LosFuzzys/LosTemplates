#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Respect the shebang and mark file as executable

import os
import random
from flask import Flask, render_template
from waitress import serve

# create and configure the app
app = Flask(__name__, instance_relative_config=True)
app.config.from_mapping(
    SECRET_KEY=random.randbytes(128)
)
@app.route('/')
def index():  # put application's code here
    print("Log something", flush=True) # flush=True is required for printing in flask applications
    return render_template('index.html')

@app.route('/flag')
def challenge():
    flag = os.environ.get('FLAG', 'FLAG{FAKE_FLAG}')
    return render_template('flag.html', flag=flag)

serve(app, host='0.0.0.0', port=1337)
