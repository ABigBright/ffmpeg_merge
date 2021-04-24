#!/bin/bash

touch flist.txt

for file in $(cat fsrc.txt)
do
    echo -e '\e[31mStart Downloading  => \e[32m'$file
    ffmpeg -i $file ${file:33:7}
    echo -e '\e[33mFinish Downloading => \e[32m'$file
    echo ${file:33:7} >> flist.txt
done

ffmpeg -f concat -safe 0 -i flist.txt -c copy output.mp4

echo -e '\e[33m=> Finish Video Merge\e[0m'
