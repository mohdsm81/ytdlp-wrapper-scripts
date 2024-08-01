#!/usr/bin/env bash

FILES=()
for file in *.{description,mp4,webp};
do
    f=$(basename -a "$file")
    FILES+=("$f")
done

# Extract unique folder names (list names)
FOLDERS=()
for file in "${FILES[@]}";
do
    fldr=$(echo "$file" | awk -F" - " '{print $2;}')
    FOLDERS+=("$fldr")
done

UNIQUE_FOLDERS=($(echo "${FOLDERS[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

# Create all folders, if they don't exist
for folder in "${UNIQUE_FOLDERS[@]}";
do
    if [ ! -d "$folder" ] && [ "$folder" != "" ]; then
        echo "creating folder: $folder"
        mkdir "$folder"
    fi
done

# Move files to their respective folders
for file in "${FILES[@]}"; do
    folder=$(echo "$file" | awk -F" - " '{print $2;}')
    if [ -d "$folder" ] && [ "$folder" != "" ]; then
        find . -mindepth 1 -maxdepth 1 -name "*$file*" -a -not -name "$folder" -exec mv -t "$folder" {} +
    fi
done
