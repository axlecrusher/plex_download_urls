#!/bin/bash 

echo "Updating Readme"

LST=( 
	linux-x86_64.debian
	linux-x86.debian
	linux-aarch64.debian
	linux-armv7neon.debian
	linux-x86.redhat
	linux-x86_64.redhat
	windows-x86.windows
	darwin-x86_64.macos
	freebsd-x86_64.freebsd )

NAS=( 
 linux-x86.synology
 linux-x86_64.synology
 linux-aarch64.synology
 linux-armv7hf.synology
 linux-armv7neon.synology
 linux-x86.synology-dsm7
 linux-x86_64.synology-dsm7
 linux-aarch64.synology-dsm7
 linux-armv7hf.synology-dsm7
 linux-armv7neon.synology-dsm7
 linux-x86_64.netgear
 linux-armv7hf.netgear
 linux-armv7neon.netgear
 linux-x86_64.qnap
 linux-aarch64.qnap
 linux-armv7hf.qnap
 linux-armv7neon.qnap
 linux-x86_64.unraid
 linux-armv7hf.drobo
 linux-x86.asustor
 linux-x86_64.asustor
 linux-aarch64.asustor
 linux-armv7neon.asustor
 linux-x86_64.terramaster
 linux-aarch64.terramaster
 linux-x86_64.thecus
 linux-x86_64.seagate
 linux-armv7hf.seagate
 linux-x86_64.wd-pr2100-os5
 linux-x86_64.wd-pr4100-os5
 linux-armv7hf.wd-ex2ultra-os5
 linux-armv7hf.wd-ex4100-os5
 linux-armv7hf.wd-mirror-os5
 linux-armv7hf.wd-ex2100-os5
 linux-x86_64.wd-dl2100-os5
 linux-x86_64.wd-dl4100-os5
 linux-armv7hf.wd-mycloud-os5
 linux-armv7hf.wd-cloud-os5
 linux-x86_64.wd-dl2100
 linux-x86_64.wd-dl4100
 linux-x86_64.wd-pr2100
 linux-x86_64.wd-pr4100
 linux-armv7hf.wd-ex2
 linux-armv7hf.wd-ex2100
 linux-armv7hf.wd-ex2ultra
 linux-armv7hf.wd-ex4100
 linux-armv7hf.wd-mirror
 linux-armv7hf.wd-mirrorgen2
)

JSONTMP=$1

echo $JSONTMP

VERSION=$(cat $JSONTMP|jq -r '.computer.Linux|.version')
if [ $? != 0 ]
then
 echo "[3;31mError parsing json[0m"
 exit
fi

if [ -z "$VERSION" ]
then
 echo "[3;31mError parsing json[0m"
 exit
fi

echo "Version $VERSION"
#echo "checkmark 1"

# grep $VERSION README.md >/dev/null
# if [ $? == 0 ] 
# then
#  echo "[3;31mAlready in Readme[0m"
#  exit
# fi

#echo "[1;33mAdding $VERSION[0m"

addUrl()
{
  local FILENAME=$2
  if [ ! -f "$FILENAME" ]; then
    echo "# $FILENAME" > "$FILENAME"
  fi

  if [ ! -z "$1" ]; then
    `grep "$1" "$FILENAME" >/dev/null`
    local URL_NOT_EXISTS=$?
#    echo $URL_NOT_EXISTS

    if [ $URL_NOT_EXISTS == 1 ]; then
      echo "[1;33m +Adding URL[0m"
      sed -i "/# $a/a \\\n$1" "$2"
    else
      echo "[3;31m -URL Already in Readme[0m"
    fi
  fi
}


old_ifs="$IFS"

for a in ${LST[@]}
do
  IFS="."
  read build distrib <<< "$a"

  echo "Search $build for $distrib"
  URL=$(cat "$JSONTMP"|jq --arg BUILD "$build" --arg DISTRO "$distrib"  -r '.computer[]|.releases[]|select(.build==$BUILD and .distro==$DISTRO)|.url')

  addUrl "$URL" "archives/$a.md"
done

# reset IFS for loop
IFS="$old_ifs"

for a in ${NAS[@]}
do
  IFS="."
  read build distrib <<< "$a"

  echo "Search $build for $distrib"
  URL=$(cat "$JSONTMP"|jq --arg BUILD "$build" --arg DISTRO "$distrib"  -r '.nas[]|.releases[]|select(.build==$BUILD and .distro==$DISTRO)|.url')

  addUrl "$URL" "archives/$a.md"

  #addUrl "$URL" README.md

done

