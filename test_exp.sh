#!/bin/bash
. config.cfg
echo "Started:" `date`

v4l2-ctl --set-ctrl auto_exposure=1 #turn auto exposure control OFF

[ -e ./$test_directory ] || mkdir ./$test_directory #create ./test_directory if doesnt exist 

for i in {100..1200..100}
do
    echo -n "Exposure setting: $i..."
    v4l2-ctl --set-ctrl exposure_time_absolute=$i

    if pgrep -x "ffmpeg" > /dev/null #check if ffmpeg stream to dummy camera is running
    then
        #save a frame in bmp
        ffmpeg -f video4linux2 -video_size 1920x1080 -input_format yuyv422 -i /dev/video2 -c:v bmp -f image2 -pix_fmt bgr24 -frames:v 1 pipe:1 > $photo_filename -hide_banner -loglevel error
    else
        #copy stream from real camera to dummy
        ffmpeg -f video4linux2 -video_size 1920x1080 -input_format yuyv422 -i /dev/video0 -codec copy -f video4linux2 /dev/video2 -hide_banner -loglevel error &
        #save a frame in bmp
        ffmpeg -f video4linux2 -video_size 1920x1080 -input_format yuyv422 -i /dev/video2 -c:v bmp -f image2 -pix_fmt bgr24 -frames:v 1 pipe:1 > $photo_filename -hide_banner -loglevel error
    fi
    echo -e " done."
done

echo -e "\nFinished:" `date`
