#!/bin/bash

for file in $(cat fsrc.txt)
do
    echo -e '\e[31mStart Downloading     => \e[32m'$file
    ffmpeg -i $file ${file:33:7}
    echo -e '\e[33m=> Finish Downloading => \e[32m'$file
done

