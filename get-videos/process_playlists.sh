#!/usr/bin/env bash

for filename in *.m3u8; do
    echo "Processing ${filename}"
    mkdir -p videos
    `dirname $0`/download.sh ${filename} videos res-${filename/%.*/}.ts
done