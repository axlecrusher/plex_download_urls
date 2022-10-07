#!/bin/bash 

echo "Grab Old Versions"

FILENAME=json/5.json
REVISIONS=$(git rev-list --all --objects $FILENAME | grep -v 'json' | tac)

old_ifs="$IFS"

for a in ${REVISIONS[@]}
do
#IFS=" "
read sha filename <<< "$a"

echo "Get revision $sha of $FILENAME"
git checkout $sha -- $FILENAME

./UpdateReadme.sh $FILENAME

done

# reset IFS
IFS="$old_ifs"