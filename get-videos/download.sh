#!/usr/bin/env bash

# Script used to download video file, which is separated to multiple segments. Video segments are defined in .m3u8 playlist
#
# Script first parses playlist file and retrieves links to all ts files, then
# downloads all the files to specified directory (if specified) and creates playlist of local files, which afterwards
# is used to merge multiple segments to entire video.

# Note: ffmpeg should be installed

case $1 in
  --help)
    show_usage
    ;;
esac

show_usage()
{
  echo "
USAGE:

`basename $0` <playlist_name> <output_directory> <output_file_name>

arguments:
  playlist_name      name of .m3u8 playlist
  output_directory   video output directory
  output_file_name   name of the output file

" >&2

  exit 1
}

FILENAME=${1?Error: no file name specified}
DIR_NAME=${2-`pwd`}
OUTPUT_NAME=${3-output.ts}


iterator=0
grep ^https.*\.ts$ ${FILENAME} | while read -r link ; do

# Variable is written to file in order to obtain value of iterator. Global variable cannot be used,
# because code executed after pipe is being executed in separate shell -> value of var iterator is not visible outside while loop
    echo ${iterator} > iterator
    echo "Processing $link"
    current=${DIR_NAME}/${iterator}.ts
    curl -L -o ${current} ${link}
    echo "file '$current'" >> playlist.txt;
    ((iterator++))
done

iterator=`cat iterator`


ffmpeg -f concat -safe 0 -i playlist.txt -c copy ${DIR_NAME}/${OUTPUT_NAME}


# Remove temporary files

for i in `seq 0 ${iterator}`; do
    rm -f ${DIR_NAME}/${i}.ts
done

rm -f playlist.txt
rm -f iterator