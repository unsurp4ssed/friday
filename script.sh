#!/bin/bash
. config.cfg

if [ ! $# -eq 0 ] 
  then
    photo_filename="$1"
fi

[ -e $photos_path ] || mkdir $photos_path #create ./photos if doesnt exist
[ -e $log_path ] || mkdir $log_path #create log path if it doesnt exist
[ -e $log_name ] || cd $log_path; touch $log_name; cd ../ #create log file


device="/dev/video"

for i in {0..10}
do
        if sudo grep -q 2688 /sys/class/video4linux/video$i/name 2>/dev/null;  then
                device+=$i
                break
        fi
        if [ $i -eq 10 ]; then
                echo -e "searched /dev/video 0 through 10, havent found star sensor camera (SPCA2688 AV Camera: SPCA2688 AV). Exiting..\n"
		echo -e `date` "searched /dev/video 0 through 10, havent found star sensor camera (SPCA2688 AV Camera: SPCA2688 AV). Exiting..\n" >> $log_path/$log_name
                exit 1
        fi
done


echo "Started:" `date`
echo -n "Changing exposure control to manual mode..."
v4l2-ctl --device $device --set-ctrl auto_exposure=1 #1 - manual exposure mode 
echo "done"

#setting exposure from config file
echo -n "Exposure setting: $exposure..."
v4l2-ctl --device $device --set-ctrl exposure_time_absolute=$exposure
echo -e " done."

ffmpeg -f video4linux2 -video_size 1920x1080 -input_format yuyv422 -i $device -c:v bmp -f image2 -pix_fmt bgr24 -frames:v 1 pipe:1 > ./$photos_path/$photo_filename -hide_banner -loglevel error 

echo -e "Written bmp file to " $photos_path"/"$photo_filename
echo -e `date` ": Written bmp file to " $photos_path"/"$photo_filename >> $log_path/$log_name

echo -e "\nStarting the algos"
echo -e `date` ": Starting the algos;" >> $log_path/$log_name
(cd ./starviz; ./starviz ../$photos_path/$photo_filename)

echo -e "\nFinished:" `date`
echo -e `date` ": finished processing " $photos_path"/"$photo_filename >> $log_path/$log_name
cat ./starviz/PIXAR.txt
