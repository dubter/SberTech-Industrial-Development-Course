#! /bin/bash
logFile=""

while true; do
 availableInodes=$(df -i / | awk '{print $4}' | sed -n '2p')
 if [ "$DATE_STAMP" != $(date +%d_%m_%Y) ]; then
  export DATE_STAMP=$(date +%d_%m_%Y)
  logFile=${START_TIME}_${DATE_STAMP}.csv
  touch $logFile
  echo -e "Current Time,\tAvailable Inodes" >> $logFile
 fi
 echo -e "$(date +%T),\t$availableInodes" >> $logFile
 sleep 10
done

