#!/bin/bash 

echo "Grab Version"

#curl -s  -I "https://plex.tv/downloads/latest/1?channel=16&build=linux-ubuntu-x86_64&distro=ubuntu&X-Plex-Token="

# Ubuntu / Debian (Intel / AMD 64Bit)
# Ubuntu / Debian (Intel / AMD 32Bit)
# Ubuntu / Debian (ARMv8)
# Ubuntu / Debian (ARMv7)
# Fedora / CentOS / SUSE (32bit)
# Fedora / CentOS / SUSE (64bit)
# Windows
# Mac
# FreeBSD

JSONTMP=/tmp/5.json
JSONFILE=./json/5.json
#echo $JSONFILE

echo "curl -w httpcode=%{http_code} -s https://plex.tv/api/downloads/5.json --output $JSONTMP 2> /dev/null"

#url for media server builds
CURL_RETURN_CODE=0
CURL_OUTPUT=`curl -w httpcode=%{http_code} -s https://plex.tv/api/downloads/5.json --output $JSONTMP 2> /dev/null` || CURL_RETURN_CODE=$?

if [ ${CURL_RETURN_CODE} -ne 0 ]; then  
    echo "Curl connection failed with return code - ${CURL_RETURN_CODE}"
    exit
else
    echo "Curl connection success"
    # Check http code for curl operation/response in  CURL_OUTPUT
    httpCode=$(echo "${CURL_OUTPUT}" | sed -e 's/.*\httpcode=//')

    if [ ${httpCode} -ne 200 ]; then
        echo "Curl operation/command failed due to server return code - ${httpCode}"
        exit
    fi
fi

./UpdateReadme.sh $JSONTMP

cp $JSONTMP $JSONFILE

