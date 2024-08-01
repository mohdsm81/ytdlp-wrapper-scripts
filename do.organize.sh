#!/usr/bin/env bash

FILES=()
for file in *.{description,mp4,webp};
do
    f=$(basename -a $file)
    FILES+=("$f");
done

# extract unique folder names (list names)
FOLDERS=()
for file in "${FILES[@]}";
do
    fldr=$(echo $file | awk -F" - " '{print $2;}')
    FOLDERS+=("$fldr")
done

# UNIQUE_FOLDERS=($(echo "${FOLDERS[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

# Get unique folder names and store them in an array
mapfile -t UNIQUE_FOLDERS < <(printf "%s\n" "${FOLDERS[@]}" | sort -u)
# echo ${FOLDERS[2]};
# echo ${UNIQUE_FOLDERS[@]};

#create all folders, if they don't exist
for folder in "${UNIQUE_FOLDERS[@]}";
do
    if [ ! -d "$folder" ] && [[ "$folder" != "" ]];
    then
        echo "creating folder: '$folder'"
        mkdir "$folder"
    fi
done

# Move files to their respective folders
for folder in "${UNIQUE_FOLDERS[@]}";
do
    if [[ -d "$folder" ]] && [[ "$folder" != "" ]]; then
        # echo *$folder*.*
        # This one is erroneous (tries to move the folder inside of itself)
        # $ (mv *$folder*.* $folder)
        find . -mindepth 1 -maxdepth 1 -name "*$folder*.*" -a -not -name "$folder" -exec mv -t "$folder" {} +
    fi
done
