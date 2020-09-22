#!/bin/bash 

script_relative_path1=`dirname $0`
echo $script_relative_path1
cd $script_relative_path1
exec &>> cron.log

now=`date +'%m/%d/%Y'`

git fetch
git pull

./Grab.sh
git commit -a -m "Link updates for $now"
#git push
