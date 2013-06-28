#!/usr/bin/env bash

# file        : daemon.sh
# description : daemon process manager 
# creator     : Tim
# version     : 1.1

# history
# 2013-06-26    Tim    First release
# 2013-06-27    Tim    Add retry
# 2013-06-28    Tim    Add comment

# constant

LOGFILE="daemon.log"
LOGMASTERFILE="daemon.master.log"
PIDFILE="daemon.pid"
PIDMASTERFILE="daemon.master.pid"

# variables

ACTION=$1
COMMAND=$2
INTERVAL=$3 
PID=''
RETRY=3
STAT=1

if [ -z "$INTERVAL" ] ; then
  INTERVAL=1
fi

# function

start_process() {
  if [ -z "$COMMAND" ] ; then
    echo "Usage: $0 start <command>" >&2
    exit 1
  fi
  $COMMAND > $LOGFILE &
  PID=$!

  sleep 1
  PSLINE=$(ps $PID | wc -l)
  if [ $PSLINE -eq 1 ]; then
    RETRY=$(($RETRY - 1))
    STAT=0
  else
    RETRY=3
    STAT=1
    echo $PID > $PIDFILE
  fi

  if [ $RETRY -lt 1 ]; then
    echo some error occured
    exit 1
  fi
}

monitor() {
  while true 
  do
    PSLINE=$(ps $PID | wc -l)
    if [ -n "$PID" -a $PSLINE -eq 1 ]; then
      start_process
      echo restart
    fi
    echo $PSLINE
    sleep $INTERVAL 
  done;
}

stop() {
  if [ -e $PIDMASTERFILE ] ; then
    kill $(cat $PIDMASTERFILE)
    rm $PIDMASTERFILE 
    echo "master has stop"
  fi

  if [ -e $PIDFILE ] ; then
    kill $(cat $PIDFILE)
    rm $PIDFILE 
    echo "child has stop"
  fi
}

start_monitor() {
  (monitor &> $LOGMASTERFILE&  [ $STAT -eq 1 ] && echo $! > $PIDMASTERFILE)
}

# main

case $ACTION in
  start)
    start_process
    start_monitor
    echo "Write log in deamon.log"
    ;;
  stop)
    stop
    ;;
  *)
    echo "Usage: $0 {start <command>|stop}" >&2
    exit 1
    ;;
esac
  
exit 0
