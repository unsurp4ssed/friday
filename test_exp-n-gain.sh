#!/bin/bash
. config.cfg

device="/dev/video"

for i in {0..10}
do
        if sudo grep -q 2688 /sys/class/video4linux/video$i/name 2>/dev/null;  then
                device+=$i
                break
        fi
        if [ $i -eq 10 ]; then
                echo -n "searched /dev/video 0 through 10, havent found star sensor camera (SPCA2688 AV Camera: SPCA2688 AV). Exiting.."
                exit 1
        fi
done


echo "Started:" `date`
echo -n "Changing exposure control to manual mode..."
v4l2-ctl --device $device --set-ctrl auto_exposure=1 #1 - manual exposure mode 
echo "done"


echo "Started:" `date`

[ -e ./$test_directory ] || mkdir ./$test_directory #create ./test_directory if doesnt exist 

for exp in {100..1200..100}
do
    echo -n "Exposure setting: $exp..."
    v4l2-ctl --device $device --set-ctrl  exposure_time_absolute=$exp

    for gain in {0..9..1} {10..50..5}
    do
    echo -n "Gain setting: $gain..."
      v4l2-ctl --device $device --set-ctrl gain=$gain
      #save a frame in bmp
      ffmpeg -f video4linux2 -video_size 1920x1080 -input_format yuyv422 -i $device -c:v bmp -f image2 -pix_fmt bgr24 -frames:v 1 pipe:1 > $test_directory/test_exp$exp.gain$gain.bmp -hide_banner -loglevel error
      echo -e " done."
    done
    
done

echo -e "\nFinished:" `date`
