#!/bin/bash

while getopts "u:e:c:o:" opt
do
    case $opt in 
        u)
            url_base=$OPTARG;;
        e)
            file_ext=$OPTARG;;
        c)
            cnt=$OPTARG;;
        o)
            output=$OPTARG;;
        ?)
            echo "error"
            exit 1
    esac
done

url_base=${url_base:-'http://www.xxx.com/media/base/'}
file_ext=${file_ext:-'.ts'}
cnt=${cnt:-0}
output=${output:-'output.mp4'}

echo ================================
echo url_base=$url_base
echo file_ext=$file_ext
echo cnt=$cnt
echo ================================

touch flist.txt

while ((1)); do

    part=$(echo $cnt|awk '{print sprintf("%0.4d", $0)}')
    url=$url_base$part$file_ext
    echo -e '\e[31mStart Downloading  => \e[32m' $url "\e[0m"

    # echo $url
    ffmpeg -i $url $part$file_ext

    if [ $? -ne 0 ]; then
        break
    fi

    # file '/home/briq/studio/tmp/ffmpeg_merge/0003.ts'
    echo "file '$(pwd)/$part$file_ext'" >> flist.txt

    # cnt++
    ((cnt++))

    echo -e '\e[33mFinish Downloading => \e[32m' $url

done

ffmpeg -f concat -safe 0 -i flist.txt -c copy $output

echo -e '\e[33m=> Finish Video Merge\e[0m'
