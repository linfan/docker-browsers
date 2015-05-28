#!/bin/bash
# Create a on cloud browser
# Usage:
# create-browser.sh <chrome/firefox> <version>

TOKEN=""

BROWSER=${1}
VERSION=${2}

SUPPORTED_BROWSER="chrome-42 chrome-41 firefox-38 firefox-37"
TIME=$(date +%Y%m%d%H%M%S)
APP_NAME="${BROWSER}-v${VERSION}-${TIME}"
HEADER_TYPE="Content-Type: application/json"
HEADER_TOKEN="Authorization:Token ${TOKEN}"
NAME_SPACE="fanlin"
SERVICE_URL="https://api.alauda.cn/v1/services/${NAME_SPACE}"

function isBrowserSupported()
{
    RES=$(echo "${SUPPORTED_BROWSER}" | grep "\b${BROWSER}-${VERSION}\b")
    if [ "${RES}" != "" ]; then
        echo "TRUE"
    else
        echo "FALSE"
    fi
}

function help()
{
    cat << END_OF_USAGE
[Error] Incorrect parameters or unsupported browser.
- Usage: create-browser.sh <chrome/firefox> <version>
- Supported browsers: ${SUPPORTED_BROWSER}
END_OF_USAGE
}

function createInstance() {
    SERVICE_DATA=$(cat << END_OF_MESSAGE
{ "app_name": "${APP_NAME}", "image_name": "index.alauda.cn/fanlin/browser-${BROWSER}-${VERSION}", 
 "image_tag": "latest", "instance_size": "XS", "scaling_mode": "MANUAL", "current_state": "Unknown", "target_state": "STARTED",
 "target_num_instances": 1, "instance_envvars": {}, "instance_ports": [ { "protocol": "tcp", "container_port": 5900 } ], 
 "linked_from_apps": {}, "linked_to_apps": {} }
END_OF_MESSAGE
)
    curl -H "${HEADER_TYPE}" -H "${HEADER_TOKEN}" -X POST -d "${SERVICE_DATA}" ${SERVICE_URL}
}

function getBrowserAddrAndPort() {
    DONE="GOING"
    while [ "${DONE}" != "" ]; do
        sleep 2s # Waiting service ready...
        RES=$(curl -H "${HEADER_TOKEN}" ${SERVICE_URL}/${APP_NAME} 2>/dev/null)
        DONE=$(echo "${RES}" | grep '"default_domain_name": null')
    done

    echo "${RES}" | sed 's#^.*"service_port": \([0-9]*\).*"default_domain_name": "\([^"]*\)".*$#\2:\1#g'
}

RES=$(isBrowserSupported)
if [ "${RES}" = "FALSE" ]; then
    help
    exit
fi

createInstance
ADDR_PORT=$(getBrowserAddrAndPort)
echo "Browser ${BROWSER} v${VERSION} started at: [ ${ADDR_PORT} ]"
