#!/bin/bash
. config.cfg
echo "Started:" `date`

if ! v4l2-ctl --list-devices | grep "Dummy" > /dev/null #check if dummy camera was already created
then
sudo modprobe v4l2loopback #create dummy camera device
fi

v4l2-ctl --set-ctrl auto_exposure=1 #turn auto exposure control OFF

[ -e ./$test_directory ] || mkdir ./$test_directory #create ./test_directory if doesnt exist 

for exp in {100..1200..100}
do
    echo -n "Exposure setting: $exp..."
    v4l2-ctl --set-ctrl exposure_time_absolute=$exp

    for gain in $(seq 0.1 0.1 1) {1..10..1} {10..99..20} {100..1000..200}
    do
    echo -n "    Gain setting: $gain..."
      if ! pgrep -x "ffmpeg" > /dev/null #check if ffmpeg stream to dummy camera is running
      then
          #copy stream from real camera to dummy
          ffmpeg -f video4linux2 -video_size 1920x1080 -input_format yuyv422 -i /dev/video0 -codec copy -f video4linux2 /dev/video2 -hide_banner -loglevel error &
      fi
      #save a frame in bmp
      ffmpeg -f video4linux2 -video_size 1920x1080 -input_format yuyv422 -i /dev/video2 -c:v bmp -f image2 -pix_fmt bgr24 -frames:v 1 pipe:1 > $test_directory/test_exp$exp.gain$gain.bmp -hide_banner -loglevel error
      echo -e " done."
    done
    
done

echo -e "\nFinished:" `date`
