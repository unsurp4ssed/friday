#!/bin/bash
if [ $# -eq 0 ] || [ $1 == '-h' ] || [ $1 == "help" ] || [ $1 == "--help" ]
  then
    echo -e "Takes your bmp as first and only argument. Example: ./take_bmp.sh filename.bmp"
    exit 1
fi

echo "Started:" `date`

sudo modprobe v4l2loopback #create dummy camera device

#copy stream from real camera to dummy
ffmpeg -f video4linux2 -video_size 1920x1080 -input_format yuyv422 -i /dev/video0 -codec copy -f video4linux2 /dev/video2 -hide_banner -loglevel error &

#save a frame in bmp
ffmpeg -f video4linux2 -video_size 1920x1080 -input_format yuyv422 -i /dev/video2 -c:v bmp -f image2 -pix_fmt bgr24 -frames:v 1 pipe:1 > $1 -hide_banner -loglevel error

echo -e "\n^ignore that :3"
echo -e "\nFinished:" `date`
