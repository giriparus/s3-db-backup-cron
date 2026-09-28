#!/bin/bash

if echo "$MONGODB_URI" | grep -q "MONGODB-AWS"; then
  
  ROLE_NAME=$(curl -s http://169.254.169.254/latest/meta-data/iam/info | awk -F'"' '/\"InstanceProfileArn\"/ { print $4 }' | sed 's:.*/::')
  AWS_CREDENTIALS=$(curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/$ROLE_NAME)
  export AWS_ACCESS_KEY_ID=$(echo "$AWS_CREDENTIALS" | awk -F'"' '/\"AccessKeyId\"/ { print $4 }')
  export AWS_SECRET_ACCESS_KEY=$(echo "$AWS_CREDENTIALS" | awk -F'"' '/\"SecretAccessKey\"/ { print $4 }')
  export AWS_SESSION_TOKEN=$(echo "$AWS_CREDENTIALS" | awk -F'"' '/\"Token\"/ { print $4 }')

fi

FILTER_ARGS=()
if [ -n "${MONGO_QUERY}" ]; then
  if [ -z "${MONGO_COLLECTION}" ]; then
    echo "MONGO_COLLECTION must be set when MONGO_QUERY is used" 1>&2
    exit 1
  fi
  FILTER_ARGS=(--collection "${MONGO_COLLECTION}" --query "${MONGO_QUERY}")
fi

if [ -z ${MONGO_DATABASES} ]; then
                                                                                                                                         
  CMD_OUT=$(mongodump --uri ${MONGODB_URI} "${FILTER_ARGS[@]}" --forceTableScan --out "./mongoBackups/db" 2>&1)                                                
  if (grep -qw "0" <<< $?) then echo "$CMD_OUT"; else echo "$CMD_OUT" 1>&2 ; fi                                                            

else

  IFS=,                                                                                                                                      
  for val in $MONGO_DATABASES;                                                                                                               
  do                                                                                                                                         
  echo $val                                                                                                                                  
  CMD_OUT=$(mongodump --uri ${MONGODB_URI}/${val} "${FILTER_ARGS[@]}" --forceTableScan --out "./mongoBackups/db" 2>&1)                                           
  if (grep -qw "0" <<< $?) then echo "$CMD_OUT"; else echo "$CMD_OUT" 1>&2 ; fi                                                              
  done                                                                                                                                   

fi