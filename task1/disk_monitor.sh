#!/bin/bash

function start() {
   if [ "$PROCESS_PID" == "" ]; then
      export START_TIME=$(date +%T)
      . logger.sh &
      export PROCESS_PID=$!
   fi
   echo "Logging process PID = $PROCESS_PID"
}

function status() {
  if [ "$PROCESS_PID" == "" ]; then
    echo "Logging process is not active!"
    else 
    echo "Logging process is active!"
    fi
}

function stop() {
  if ! [ "$PROCESS_PID" == "" ]; then
      kill $PROCESS_PID
      unset PROCESS_PID
      echo "Logging process has been terminated!"
  fi
}

case $1 in
"START") 
    start
    ;;
"STATUS") 
    status
    ;;
"STOP") 
    stop
    ;;
*)
    echo "choose option START | STATUS | STOP"
    ;;
esac
