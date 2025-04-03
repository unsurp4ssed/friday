#!/bin/bash

echo "Started:" `date`

# set -e

. config.cfg

#setting exposure
echo -n "Exposure setting: $exposure..."
# v4l2-ctl --set-ctrl auto_exposure=1 #1 - manual exposure mode 
v4l2-ctl --set-ctrl exposure_time_absolute=$exposure
echo -e " done."

#save a frame in bmp
ffmpeg -f video4linux2 -video_size 1920x1080 -input_format yuyv422 -i /dev/video2 -c:v bmp -f image2 -pix_fmt bgr24 -frames:v 1 pipe:1 > ./photos/$photo_filename -hide_banner -loglevel error

echo -e "Written bmp file to ~/photos/$photo_filename"

echo -e "\nStarting the algos"

# set +e

(cd ./starviz; ./starviz ../photos/$photo_filename)

echo -e "\nFinished:" `date`
