#!/bin/bash
echo "0 ${HOUR_OF_DAY:-23} * * 1-6 /opt/backup/script.sh /opt/backup > /dev/stdout" > crontab.txt
/usr/bin/crontab crontab.txt

/usr/sbin/crond -f -l 8