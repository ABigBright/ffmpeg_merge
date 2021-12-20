#!/bin/bash

if [ $# -le 1 ]; then
    echo Download fragment video stream and merge into a signal video stream with ffmpeg.
    echo -e "Example : \"$0 -u 'https://www.xxx.com/' -e .ts -c 12 -o 'output.mp4' -s '?download'\" \r\nIt will download video stream from https://www.xxx.com/0012.ts?download"
    echo "-u specify the base url, such as \"https://www.xxx.com/\""
    echo "-e file extension suffix"
    echo "-c file start index"
    echo "-o output file name"
    echo "-s specify the url suffix part"
    echo "-n file index width, such as when n=4, it expand \"1\" to \"0001\""
    echo "-p file index prefix part"
    echo "-S file index suffix part"
    # exit -1
fi

while getopts "u:e:c:o:s:n:p:S:" opt
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
        s)
            url_suffix=$OPTARG;;
        n)
            part_num_width=$OPTARG;;
        p)
            part_num_prefix=$OPTARG;;
        S)
            part_num_suffix=$OPTARG;;
        ?)
            echo "error"
            exit 1
    esac
done

url_base=${url_base:-'http://www.xxx.com/media/base/'}
file_ext=${file_ext:-'.ts'}
cnt=${cnt:-0}
output=${output:-'output.mp4'}
url_suffix=${url_suffix:-''}
part_num_width=${part_num_width:-'4'}
part_num_prefix=${part_num_prefix:-''}
part_num_suffix=${part_num_suffix:-''}

echo ================================
echo url_base=$url_base
echo file_ext=$file_ext
echo cnt=$cnt
echo output=${output}
echo url_suffix=${url_suffix}
echo part_num_width=${part_num_width}
echo part_num_prefix=${part_num_prefix}
echo part_num_suffix=${part_num_suffix}
echo ================================

touch flist.txt

while ((1)); do

    part_num_width_str="%0."$part_num_width"d"
    part_cmd_str="echo \$cnt|awk '{print sprintf(\"$part_num_width_str\", \$0)}'"
    part=$(eval $part_cmd_str)
    # part=$(echo $cnt|awk '{print sprintf($(part_num_width_str), $0)}')
    # echo $part
    url=$url_base$part_num_prefix$part$part_num_suffix$file_ext$url_suffix
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
