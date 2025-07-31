#!/bin/bash

if [ ! $# -eq 0 ] 
  then
    photo_filename="$1"
fi

echo "Started:" `date`

# set -e

. config.cfg

echo -n "Changing exposure control to manual mode..."
v4l2-ctl --set-ctrl auto_exposure=1 #1 - manual exposure mode 
echo "done"
#setting exposure from config file
echo -n "Exposure setting: $exposure..."
v4l2-ctl --set-ctrl exposure_time_absolute=$exposure
echo -e " done."

if ! v4l2-ctl --list-devices | grep "Dummy" > /dev/null #check if dummy camera was already created
then
    sudo modprobe v4l2loopback #create dummy camera device
fi

if ! pgrep -x "ffmpeg" > /dev/null #check if ffmpeg stream to dummy camera is running
then
    #copy stream from real camera to dummy
    ffmpeg -f video4linux2 -video_size 1920x1080 -input_format yuyv422 -i /dev/video0 -codec copy -f video4linux2 /dev/video2 -hide_banner -loglevel error &
fi
#save a frame in bmp
ffmpeg -f video4linux2 -video_size 1920x1080 -input_format yuyv422 -i /dev/video2 -c:v bmp -f image2 -pix_fmt bgr24 -frames:v 1 pipe:1 > $photo_filename -hide_banner -loglevel error

echo -e "Written bmp file to ~/photos/$photo_filename"

echo -e "\nStarting the algos"

# set +e

(cd ./starviz; ./starviz ../photos/$photo_filename)

echo -e "\nFinished:" `date`
