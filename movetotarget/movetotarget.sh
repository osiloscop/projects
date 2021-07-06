#!/bin/bash

source_path="$1"
target_path="$2"

while true
do
    for file in "$source_path"/*
        do
            if [ -f "$file" ]; then
                mv "$file" "$target_path"
                echo "$file is copied."
            fi
        done
    sleep 1
done




