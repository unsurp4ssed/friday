#!/bin/bash
. ../config.cfg
echo "Started:" `date`

[ -e ./$test_directory ] || mkdir ./$test_directory #create ./test_directory if doesnt exist 

for i in {1..20}
do
    v4l2-ctl -d /dev/video0 --set-fmt-video=width=1920,height=1080,pixelformat=MJPG --stream-mmap --stream-to=./$test_directory=test-series-manual$i.jpg --stream-count=1
    sleep 1s
    echo "test-series-manual$i.jpg done..."
done

echo -e "\nFinished:" `date`
