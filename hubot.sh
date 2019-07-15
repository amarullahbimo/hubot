#!/bin/bash

action=$1
slackToken=$HUBOT_SLACK_TOKEN
pathLog=log/zltch.log
jarvisRoot=$HUBOT_SLACK_ROOT
hubotCmd=$HUBOT_SLACK_ROOT/bin/hubot
pid=$(ps ax | grep zltch | grep -v grep | awk '{print $1}')

help(){
  printf "How to use this script: \n"
  printf "$0 start \n"
  printf "start   : start application \n"
  printf "stop    : kill application \n"
  printf "restart : restart application \n"
  printf "help    : how to use \n"
}

boot(){
  if [ "x$slackToken" == "x" ]; then
    echo "Slack token empty\n\n"
    help
    exit 1
  fi
  HUBOT_SLACK_TOKEN=$slackToken $hubotCmd --adapter slack >> $pathLog 2>&1 &
  [ "x$pid" == "x" ] && print "Hubot Booting ..."
}

down(){
  while [[ "x$pid" != "x" ]]; do
    kill -TERM $pid
    pid="`ps ax | grep zltch | grep -v grep | awk '{print $1}'`"
    [ "x$pid" == "x" ] && printf "Hubot has been fall\n"
  done
}

case $action in
  start )
    boot
    ;;
  stop )
    down
    ;;
  restart )
    down
    boot
    ;;
  help )
    help
    ;;
  * )
    help
    ;;
esac
