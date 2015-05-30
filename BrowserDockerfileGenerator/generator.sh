#!/bin/bash

function generateEntrypointScript()
{
    PATTERN=${1}
    BROWSER_PATH=${2}
    for folder in $(ls -d ../${PATTERN}*); do 
        cp entry_point.template ${folder}/entry_point.sh
        sed -i "s#%BROWSER_PATH%#${BROWSER_PATH}#g" ${folder}/entry_point.sh
    done
}

function generateFirefoxEntrypointScript()
{
    generateEntrypointScript "FirefoxBrowser" "/opt/firefox/firefox --setDefaultBrowser"
}

function generateChromeEntrypointScript()
{
    generateEntrypointScript "ChromeBrowser" "/opt/google/chrome/chrome"
}

function generateFirefoxDockerfile()
{
    for folder in $(ls -d ../FirefoxBrowser*); do 
        source ${folder}/AutoGen.conf
        cp FirefoxBrowserDockerfile.template ${folder}/Dockerfile
        sed -i "s#%DEPENDENCE_DEB%#${DEPENDENCE_DEB}#g" ${folder}/Dockerfile
        sed -i "s#%BROWSER_DEB%#${BROWSER_DEB}#g" ${folder}/Dockerfile
        sed -i "s#%EXTRA_COMMAND%#${EXTRA_COMMAND}#g" ${folder}/Dockerfile
    done
}

function generateChromeDockerfile()
{
    for folder in $(ls -d ../ChromeBrowser*); do 
        source ${folder}/AutoGen.conf
        cp ChromeBrowserDockerfile.template ${folder}/Dockerfile
        sed -i "s#%BROWSER_DEB%#${BROWSER_DEB}#g" ${folder}/Dockerfile
        sed -i "s#%EXTRA_COMMAND%#${EXTRA_COMMAND}#g" ${folder}/Dockerfile
    done
}

function generateMakefile()
{
    PATTERN=${1}
    for folder in $(ls -d ../${PATTERN}*); do 
        source ${folder}/AutoGen.conf
        cp Makefile.template ${folder}/Makefile
        sed -i "s#%BROWSER%#${BROWSER}#g" ${folder}/Makefile
        sed -i "s#%VERSION%#${VERSION}#g" ${folder}/Makefile
    done
}

function generateFirefoxMakefile()
{
    generateMakefile "FirefoxBrowser"
}

function generateChromeMakefile()
{
    generateMakefile "ChromeBrowser"
}

function generateReadme()
{
    PATTERN=${1}
    for folder in $(ls -d ../${PATTERN}*); do 
        source ${folder}/AutoGen.conf
        cp README.template ${folder}/README.md
        sed -i "s#%BROWSER%#${BROWSER}#g" ${folder}/README.md
        sed -i "s#%VERSION%#${VERSION}#g" ${folder}/README.md
    done
}

function generateFirefoxReadme()
{
    generateReadme "FirefoxBrowser"
}

function generateChromeReadme()
{
    generateReadme "ChromeBrowser"
}

FOLDERS=${1}
FILES=${2}

if [ "${FOLDERS:0:1}" = "f" ]; then
    FOLDERS="firefox"
elif [ "${FOLDERS:0:1}" = "c" ]; then
    FOLDERS="chrome"
else
    FOLDERS="all"
fi

if [ "${FILES:0:1}" = "e" ]; then
    FILES="entrypoint"
elif [ "${FILES:0:1}" = "d" ]; then
    FILES="dockerfile"
elif [ "${FILES:0:1}" = "m" ]; then
    FILES="makefile"
elif [ "${FILES:0:1}" = "r" ]; then
    FILES="readme"
else
    FILES="all"
fi

COMMAND="${FOLDERS}-${FILES}"
if [ ${COMMAND} = "firefox-entrypoint" ]; then
    generateFirefoxEntrypointScript
elif [ ${COMMAND} = "firefox-dockerfile" ]; then
    generateFirefoxDockerfile
elif [ ${COMMAND} = "firefox-makefile" ]; then
    generateFirefoxMakefile
elif [ ${COMMAND} = "firefox-readme" ]; then
    generateFirefoxReadme
elif [ ${COMMAND} = "firefox-all" ]; then
    generateFirefoxEntrypointScript
    generateFirefoxDockerfile
    generateFirefoxMakefile
    generateFirefoxReadme
elif [ ${COMMAND} = "chrome-entrypoint" ]; then
    generateChromeEntrypointScript
elif [ ${COMMAND} = "chrome-dockerfile" ]; then
    generateChromeDockerfile
elif [ ${COMMAND} = "chrome-makefile" ]; then
    generateChromeMakefile
elif [ ${COMMAND} = "chrome-readme" ]; then
    generateChromeReadme
elif [ ${COMMAND} = "chrome-all" ]; then
    generateChromeEntrypointScript
    generateChromeDockerfile
    generateChromeMakefile
    generateChromeReadme
elif [ ${COMMAND} = "all-entrypoint" ]; then
    generateFirefoxEntrypointScript
    generateChromeEntrypointScript
elif [ ${COMMAND} = "all-dockerfile" ]; then
    generateFirefoxDockerfile
    generateChromeDockerfile
elif [ ${COMMAND} = "all-makefile" ]; then
    generateFirefoxMakefile
    generateChromeMakefile
elif [ ${COMMAND} = "all-readme" ]; then
    generateFirefoxReadme
    generateChromeReadme
else # all-all
    generateFirefoxEntrypointScript
    generateFirefoxDockerfile
    generateFirefoxMakefile
    generateChromeEntrypointScript
    generateChromeDockerfile
    generateChromeMakefile
    generateFirefoxReadme
    generateChromeReadme
fi

