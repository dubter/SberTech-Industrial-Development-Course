#!/bin/bash

function deamonFunc() {
  while true; 
    do
      timestamp=$(date +%T)
      cpu=$(ps -Ao pcpu | awk '{sum+=$1} END {print sum}')
      mem=$(ps -Ao pmem | awk '{sum+=$1} END {print sum}')
      echo "$timestamp;$cpu;$mem;" >> time_cpu_mem.csv
      sleep 600
  done
}

export -f deamonFunc

function status() {
  pid=$(cat pid.txt)
  if [ -z "$pid" ] ; then
    echo "there are no process"
  elif ps -p $pid > /dev/null 2>&1; then
      echo "process with PID=$pid is running"
  else 
      echo "process with PID=$pid is not running"
  fi
}

function start() {
  if [ -f "time_cpu_mem.csv" ]; then
    rm time_cpu_mem.csv
    rm -f pid.txt
  fi
  touch time_cpu_mem.csv
  touch pid.txt

  nohup bash -c deamonFunc > /dev/null 2>&1 &
  echo "start process with PID=$!"
  echo $! > pid.txt
}

function killProcess() {
  if processChilds="$(pgrep -P $1)"; then
      for child in $processChilds; do
          killProcess $child
      done
  fi
  if ps -p $1 > /dev/null 2>&1; then 
      kill -9 $1
  fi
}

function stop() {
    if pid=$(cat pid.txt); then 
        killProcess $pid
    fi
    echo "process with PID=$pid stopped"
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
