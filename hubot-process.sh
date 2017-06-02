#!/bin/bash

name="process.count.hubot"
monitor_time=`date +%s`
count=`ps aux | grep node | grep hubot | grep -v grep | wc -l`
echo -e "${name}\t${count}\t${monitor_time}"
