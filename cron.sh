#!/bin/bash 

script_relative_path1=`dirname $0`
#echo $script_relative_path1
cd $script_relative_path1
./automateUpdate.sh | tai64n >> cron.log
