#!/bin/bash
time=$(date +%m-%d-%y_%H_%M_%S)
backup_file=/home/ubuntu/bash
dest=/home/ubuntu/backup
filename=file-backup-$time.tar.gz
LOG_FILE="/home/ubuntu/backup/logfile.log"
s3_Bucket="s3-bash-hawil"
file_TO_upload="$dest/$filename" 

### Check if user enter  the path file to backup 
#
#if [ -z "$backup_file" ]; then
#       echo " Please enter the directory that U want to backup at ---> $(date)" | tee  -a "$LOG_FILE"
#       exit 2
#fi
if ! command -v aws &> /dev/null
then
        echo "AWS CLI ir not installed. Please install it first"
        exit 2
fi


if [ $? -ne 2 ]; then
 if [ -f $filename ]; then
        echo "Error file $filename already exists!" | tee -a  "$LOG_FILE"
 else
        tar -czvf "$dest/$filename"  "$backup_file"
        echo "backup completed successfully .  BackUp file: $dest/$filename " | tee -a "$LOG_FILE" 
        echo
        aws s3 cp "$file_TO_upload" "s3://$s3_Bucket/"
 fi
fi 

if [ $? -eq 0 ] ; then
        echo
        echo "File Uploaded successfully to the S2 bucket : $s3_Bucket"
else
        echo "File upload tp s3 failed"
fi
echo "This Script provided by eng-$eng"