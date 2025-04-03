#!/bin/bash
[ -e ./photos ] || mkdir ./photos #create ~/photos if doesnt exist 
echo -n "Changing exposure control to manual mode..."

set -e 

v4l2-ctl --set-ctrl auto_exposure=1 #1 - manual exposure mode 
echo "done"

echo -n "initialising camera..."

touch ffmpeg_stream.log

sudo modprobe v4l2loopback #create dummy camera device 

#copy stream from real camera to dummy
ffmpeg -f video4linux2 -video_size 1920x1080 -input_format yuyv422 -i /dev/video0 -codec copy -f video4linux2 /dev/video2 -hide_banner -loglevel error &

echo -e "done"