#!/bin/bash
# Create a on cloud browser
# Usage:
# create-browser.sh <chrome/firefox> <version>

TOKEN="${ALAUDA_TOKEN}"

BROWSER=${1}
VERSION=${2}

SUPPORTED_BROWSER="chrome-42 chrome-41 firefox-38 firefox-37 firefox-36 firefox-35 firefox-34 firefox-33 firefox-32 firefox-31 firefox-30 firefox-29 firefox-28 firefox-27 firefox-26 firefox-25 firefox-24 firefox-23 firefox-22 firefox-21 firefox-20 firefox-19 firefox-18 firefox-17 firefox-16 firefox-15 firefox-14"
TIME=$(date +%Y%m%d%H%M%S)
APP_NAME="${BROWSER}-v${VERSION}-${TIME}"
HEADER_TYPE="Content-Type: application/json"
HEADER_TOKEN="Authorization:Token ${TOKEN}"
NAME_SPACE="fanlin"
SERVICE_URL="https://api.alauda.cn/v1/services/${NAME_SPACE}"

function isTokenAdded()
{
    if [ "${TOKEN}" = "" ]; then
        echo "FALSE"
    else
        echo "TRUE"
    fi
}

function isBrowserSupported()
{
    RES=$(echo "${SUPPORTED_BROWSER}" | grep "\b${BROWSER}-${VERSION}\b")
    if [[ "${BROWSER}" != "" && "${VERSION}" != "" && "${RES}" != "" ]]; then
        echo "TRUE"
    else
        echo "FALSE"
    fi
}

function error()
{
    REASON="${1}"
    case ${REASON} in
        "NO_TOKEN" )
    cat << END_OF_USAGE
[Error] Empty token, please set your alauda token number to ALAUDA_TOKEN environment variable.
END_OF_USAGE
        ;;
        * )
    cat << END_OF_USAGE
[Error] Incorrect parameters or unsupported browser.
- Usage: create-browser.sh <chrome/firefox> <version>
- Supported browsers: ${SUPPORTED_BROWSER}
END_OF_USAGE
        ;;
    esac
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
    DONE=""
    while [ "${DONE}" = "" ]; do
        sleep 2s # Waiting service ready...
        RESPOND=$(curl -H "${HEADER_TOKEN}" ${SERVICE_URL}/${APP_NAME} 2>/dev/null)
        DONE=$(echo "${RESPOND}" | grep '"service_port":[ ]*[0-9]*,')
    done

    echo "${RESPOND}" | sed 's#^.*"service_port": \([0-9]*\).*"default_domain_name": "\([^"]*\)".*$#\2:\1#g'
}

RES=$(isTokenAdded)
if [ "${RES}" = "FALSE" ]; then
    error "NO_TOKEN"
    exit
fi

RES=$(isBrowserSupported)
if [ "${RES}" = "FALSE" ]; then
    error "INVALID_PARA"
    exit
fi

createInstance
ADDR_PORT=$(getBrowserAddrAndPort)
echo "Browser ${BROWSER} v${VERSION} started at: [ ${ADDR_PORT} ]"
