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
        find . -mindepth 1 -maxdepth 1 -name "*- $folder -*.*"  -exec mv -t "$folder" {} +
    fi
done

CHANNEL_FOLDER=$(echo $FILES[0] | awk -F ' - ' '{print $1;}')
if [[ ! -d "$CHANNEL_FOLDER" ]]; then
    mkdir "$CHANNEL_FOLDER"
fi

# before moving the folders, in fear of overwriting a previous one inside the
# channel folder, check if it exists. Then, move all files beloning to the same
# folder into the one inside the channel's folder Last, delete the root-level
# empty folder.

# Move all folders containing the files into the channel folder
echo "Moving all folders to the channel folder: '$CHANNEL_FOLDER'"

for folder in "${UNIQUE_FOLDERS[@]}";
do
    if [[ -d "${folder}" ]] && [[ "$folder" != "$CHANNEL_FOLDER" ]];
    then
        if [[ -d "$CHANNEL_FOLDER/$folder" ]];
        then
            echo "Moving contents of $folder == to ==> $CHANNEL_FOLDER/$folder"
            mv "$folder"/* "$CHANNEL_FOLDER/$folder"
            # delete local folder
            rmdir "$folder"
        else
            echo "Moving folder $folder == to ==> $CHANNEL_FOLDER"
            # create a subfolder inside the channel's
            mkdir "$CHANNEL_FOLDER/$folder"
            # move files of the local folder itself inside the channel folder
            mv "$folder"/* "$CHANNEL_FOLDER/$folder"
            # remove the local folder
            rmdir "$folder"
        fi
    fi
done

# OLD, remove when done
# find . -mindepth 1 -maxdepth 1 -type d -not -name "$CHANNEL_FOLDER" -exec mv -t "$CHANNEL_FOLDER" {} +
