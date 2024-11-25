#!/bin/bash

_term() {
  echo "Caught SIGTERM signal!"
  [[ $apache_service ]] && kill -TERM "$apache_service"
  [[ $bot_service ]] && kill -TERM "$bot_service"
}

_int() {
  echo "Caught SIGINT signal!"
  [[ $apache_service ]] && kill -INT "$apache_service"
  [[ $bot_service ]] && kill -INT "$bot_service"
}

trap _term SIGTERM
trap _int SIGINT

apache2-foreground 2>&1 &
apache_service=$!
python3 /bot/main.py 2>&1 &
bot_serivce=$!

wait -n
exit $?
