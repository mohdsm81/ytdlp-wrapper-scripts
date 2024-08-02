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

# Get unique folder names and store them in an array
mapfile -t UNIQUE_FOLDERS < <(printf "%s\n" "${FOLDERS[@]}" | sort -u)

#create all folders, if they don't exist
echo "Creating folders: "
for folder in "${UNIQUE_FOLDERS[@]}";
do
    if [ ! -d "$folder" ] && [[ "$folder" != "" ]];
    then
        echo "'$folder'"
        mkdir "$folder"
    fi
done



# Move files to their respective folders
echo "Moving files to their respective folder (i.e. a folder per playlist)"
for folder in "${UNIQUE_FOLDERS[@]}";
do
    if [[ -d "$folder" ]] && [[ "$folder" != "" ]]; then
        find . -mindepth 1 -maxdepth 1 -name "*- $folder -*.*" -a -not -name "$folder" -exec mv -t "$folder" {} +
    fi
done

# Move all folders containing the files into the channel folder
# Move files to their respective folders
CHANNEL_FOLDER=$(echo $FILES[0] | awk -F ' - ' '{print $1;}')
echo "Moving all folders to the channel folder: '$CHANNEL_FOLDER'"
find . -mindepth 1 -maxdepth 1 -not -name "*.sh" -a -not -name "$CHANNEL_FOLDER" -exec mv -t "$CHANNEL_FOLDER" {} +
