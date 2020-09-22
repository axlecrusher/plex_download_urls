#!/bin/bash 

now=`date +'%m/%d/%Y'`

git fetch
git pull

./Grab.sh
git commit -a -m "Link updates for $now"
#git push
