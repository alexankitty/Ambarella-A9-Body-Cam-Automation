#!/bin/bash
# Requirements. Relies on findmnt, mountpoint, cifsutils
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
mountPath=
fileServerMount=
serverHost=
dryrun=true

is_mounted() {
    findmnt --source "$1" > "/dev/null"
}

unmount_auto_retry() {

busy=true
while $busy
do
 if mountpoint -q "$1"
 then
  umount "$1" 2> /dev/null
  if [ $? -eq 0 ]
  then
   busy=false  # umount successful
  else
   echo -n 'Failed to unmount, trying again in 5 seconds.'  # output to show that the script is alive
   sleep 5      # 5 seconds for testing, modify to 300 seconds later on
  fi
 else
  busy=false  # not mounted
 fi
done
}

cp_p()
{

    filename=$(basename ${1})
    strace -q -ewrite cp -- "${1}" "${2}" 2>&1 \
        | awk '{
        count += $NF
                if (count % 10 == 0) {
                    percent = count / total_size * 100
                    left = percent * size / 100
                    printf "%3d%%[", percent
                    for (i=0;i<=percent;i++)
                        printf "="
                    printf ">"
                    for (i=percent;i<100;i++)
                        printf " "
                    printf "] " left "/" size "\r"
                }
            }
            END { print ""}' total_size=$(stat -c '%s' "${1}") count=0 size=$(du -h ${1} | awk '{print $1}')
            echo "$filename copied sucessfully."
}

python enableUSBMode.py
sleep 5 # Sleep until devices are mounted
mkdir $mountPath
mkdir $fileServerMount
mount -t cifs $serverHost $fileServerMount -o cred=$SCRIPT_DIR/sambaCreds,vers=3.0
#mount block devices sequentially
for blk in /dev/sd*1
do
    if ! is_mounted $blk; then
        usbPath=$(udevadm info -q path -n $blk | cut -d'/' -f7)
        success=true
        mount $blk $mountPath
        if [ -d "$mountPath/DCIM" ]; then
            #Get Officer name
            fileCheck=(mount/DCIM/*/*)
            name=$(basename $fileCheck | cut -d2 -f1 | tr --delete 0_)
            if [ ! -d "$fileServerMount/$name" ]; then
                mkdir $fileServerMount/$name
            fi
            echo "Copying files from $name's bodycam on $blk ($usbPath), please do not remove the device!"
            for folder in $mountPath/DCIM/*
            do
                filename=$(basename $folder)
                year=$(echo $filename | cut -c1-2)
                month=$(echo $filename | cut -c3-4)
                day=$(echo $filename | cut -c5-6)
                echo "Organizing files."
                if [ ! -d "$fileServerMount/$name/20$year" ]; then
                    mkdir $fileServerMount/$name/20$year
                fi
                if [ ! -d "$fileServerMount/$name/20$year/$month" ]; then
                    mkdir $fileServerMount/$name/20$year/$month
                fi
                if [ ! -d "$fileServerMount/$name/20$year/$month/$day" ]; then
                    mkdir $fileServerMount/$name/20$year/$month/$day
                fi
                echo "Copying $month/$day/$year."
                for video in $folder/*
                do
                    videoname=$(basename $video)
                    extension="${video##*.}"
                    time=$(echo $videoname | cut -c 21-26)
                    if [ "$extension" == "MP4" ]; then
                        location=$(python ExtractAndProcessGPS.py $video)
                        location=$(echo $location | cut -c -20) #Truncate to 20 chars
                        echo $location
                        cp_p "$video" "$fileServerMount/$name/20$year/$month/$day/$time $location.$extension"
                        if [ $? -ne 0 ]; then
                            success=false
                        fi
                    else
                        cp_p "$video" "$fileServerMount/$name/20$year/$month/$day/$time.$extension"
                        if [ $? -ne 0 ]; then
                            success=false
                        fi
                    fi
                done
            done
            if [ $dryrun = false -a $success = true ]; then
                rm -rf $mountPath/DCIM/*
            else
                echo "Not all files copied successfully or this is a dry run, skipping removal"
            fi
        else
            echo "No files to copy from $blk, continuing."
        fi
        echo "Unmounting $name's bodycam."
        unmount_auto_retry $mountPath
    fi
done
unmount_auto_retry $fileServerMount
rmdir $mountPath
rmdir $fileServerMount
