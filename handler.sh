#!/usr/bin/env bash

# Comes from inotifywait. See watcher.sh
datetime=$1
dir=$2
filename=$3
event=$4

#echo "Event: $datetime $dir $filename $event"
#echo "Here's the extensionless filename:" ${filename%.*}
#echo "And the extension if needed:" ${filename##*.}

if [ ${filename##*.} == 'fits' ]; then
  /usr/bin/solve-field "${filename}"
fi
