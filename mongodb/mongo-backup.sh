#!/bin/bash
 
# Read the array values with space
IFS=,
for val in $MONGO_DATABASES; 
do
echo $val
CMD_OUT=$(mongodump --uri ${MONGODB_URI}/${val} --forceTableScan --out "./mongoBackups/db" 2>&1)
if (grep -qw "0" <<< $?) then echo "$CMD_OUT"; else echo "$CMD_OUT" 1>&2 ; fi
done