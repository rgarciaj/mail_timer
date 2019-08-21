#!/bin/bash

if [ "$1" != "start" ] && [ "$1" != "stop" ]
then
  echo "'$1' is not one of the allowed parameters (start, stop)"

else
  
  if [ "$1" == "start" ]
  then
    puma -p 3030 -d --pidfile pid
    echo "PID: $(cat ./pid)"

  elif [ "$1" == "stop" ]
  then
    echo "Stopping server..."

    if [ -f ./pid ]
    then
      kill -9 $(cat ./pid)
      rm ./pid
      echo "Server stop"

      echo "Deleting cache..."
      rm ./gifs/*.gif
      rm tmp/frames/*
      echo "Done, bye!"

    else
      echo "PID not found! can't stop the server"
      
    fi

  fi

fi