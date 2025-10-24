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

photos_taken=0

while true
do
	i=0
	while true
	do
	        if sudo grep -q 2688 /sys/class/video4linux/video$i/name 2>/dev/null;  then
	                device+=$i
	                break
	        fi
	        if [ $i -eq 10 ]; then
	                echo -e "searched /dev/video 0 through 10, havent found star sensor camera (SPCA2688 AV Camera: SPCA2688 AV). Starting again in 2 seconds.."
			echo -e `date` "searched /dev/video 0 through 10, havent found star sensor camera (SPCA2688 AV Camera: SPCA2688 AV). Starting again in 2 seconds" >> $log_path/$log_name
			i=0
			sleep 2s
	        fi
		((i+=1))
	done

	v4l2-ctl --device $device --set-ctrl auto_exposure=1 #1 - manual exposure mode 
	#setting exposure from config file
	v4l2-ctl --device $device --set-ctrl exposure_time_absolute=$exposure

	ffmpeg -f video4linux2 -video_size 1920x1080 -input_format yuyv422 -i $device -c:v bmp -f image2 -pix_fmt bgr24 -frames:v 1 pipe:1 > ./$photos_path/$photo_filename -hide_banner -loglevel error 

	echo -e `date` ": Written bmp file to ./photos/" $photo_filename >> $log_path/$log_name
	echo -e `date` ": Starting the algos;" >> $log_path/$log_name
	(cd ./starviz; ./starviz ../$photos_path/$photo_filename)
	echo -e `date` ": finished processing " $photo_filename "photo#" $photos_taken >> $log_path/$log_name
	((photos_taken+=1))
	device="/dev/video"

done
