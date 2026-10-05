#!/bin/bash

#FILENAME=mongobackup-`date "+%Y-%m-%d-%H:%M:%S"`.tar.gz
FILENAME=mongobackup.tar.gz

tar czf ./mongoBackups/${FILENAME} ./mongoBackups/db/*

prefix=${S3_PREFIX:+"${S3_PREFIX%/}/"}
key="$prefix"mongo-backup/"$FILENAME"

test -f ./mongoBackups/${FILENAME} && aws s3api put-object --bucket $BUCKET_NAME --key "$key" --body ./mongoBackups/${FILENAME}
