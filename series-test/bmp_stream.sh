#!/bin/bash
. ../config.cfg
echo "Started:" `date`

[ -e ./$test_directory ] || mkdir ./$test_directory #create ./test_directory if doesnt exist 

for i in {1..20}
do
    ffmpeg -f video4linux2 -video_size 1920x1080 -input_format yuyv422 -i /dev/video2 -c:v bmp -f image2 -pix_fmt bgr24 -frames:v 1 pipe:1 > $test_directory/test-series-bmp_script$i.bmp -hide_banner -loglevel error
    sleep 1s
    echo "test-series-bmp_script$i.bmp done..."
done

echo -e "\nFinished:" `date`
