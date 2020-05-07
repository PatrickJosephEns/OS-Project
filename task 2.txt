#!/bin/bash
namedate=$(date +"%Y-%m-%d_%I-%M-%p")
dpath="$1"

if [ -z "$1" ]
  then
    echo "Please enter the file path you wish to backup:"
    read dpath
fi

echo -e "\n\nChecking to see if the path $dpath is a valid directory ...\n"
sleep 1s

if [ -d "$dpath" ]
then
    echo "The directory $dpath exists."
    echo -e "\n\nCreating $dpath Backup ...\n"
    sleep 2s
    tar -czvf backup-$namedate.tar.gz $dpath
    echo -e "\n\nBackup creation was successful\n"

    echo "Please enter the remote servers Host:"
    read host
    echo "Please enter the remote servers Port:"
    read port
    echo "Please enter the remote servers Username:"
    read user
    echo "Please enter the remote servers Destination:"
    read destination


    find . -type f -name "backup-$namedate.tar.gz" -exec basename {} ; |
    while read filename ; do 
      scp -P $port $filename $user@$host:$destination
      if [ $? -eq 0 ]
      then
          echo -e "\n\nSuccessfully uploaded file.\n"
      else
          echo -e"\n\nFailed Uploading file\n"
      fi
    done
else
    echo "Error: Directory $dpath does not exist."
fi