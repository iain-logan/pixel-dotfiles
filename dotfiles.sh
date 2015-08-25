#!/bin/bash

backUpDir=~/oldDotFiles
scriptPath=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

echo "";

# Check if folders where specified
if (( $# != 0 ))
then

    # User specified specific folders to load dotfiles from

    echo "Searching for user defined folders..."
    folders=$@

    for folder in $folders; do
        if [ ! -d "$scriptPath/$folder" ];
        then
            echo "  $folder does not exist. Stopping."
            exit 128
        else
            echo "  Found $folder..."
        fi
    done

    echo "All folders found"

else

    # User didn't specify folders, so we just get all of them
    echo "Using all folders..."
    folders=$(find $scriptPath/* -type d -printf "%f\n")

fi

echo ""
if [ ! -e $backUpDir ];
then
    echo "Creating backup folder $backUpDir..."
    mkdir $backUpDir
else
    if [ ! -d "$backUpDir" ];
    then
        echo "$backUpDir is not a directory."
        echo "Either change the value of the \$backUpDir variable in this script, or remove the file $backUpDir"
        exit 126
    else
        echo "Using the existing back up folder $backUpDir"
    fi
fi
echo "Creating backups and syslinks"

for folder in $folders; do
    echo "  $folder:"
    for file in $(find $scriptPath/$folder -type f -printf "%f\n"); do
        if [ -f ~/.$file ];
        then
            mv ~/.$file $backUpDir
            echo "    $file backed up to $backUpDir"
        else
            echo "    $file does not yet exist, no backup needed"
        fi
        echo "    Adding symlink to $file in ~/"
        ln -s $scriptPath/$folder/$file ~/.$file
    done
done

