#!/bin/bash
HOSTS=""
# no ping request
COUNT=1
# email report when
SUBJECT="Server Down"
EMAILID="email@email.com"
for myHost in $HOSTS
do
  count=$(ping -c $COUNT $myHost | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }')
  if [ $count -eq 0 ]; then
    # 100% failed
    echo "Host : $myHost está off? Na data: $(date)" | mail -s "$SUBJECT" $EMAILID
  fi
done
