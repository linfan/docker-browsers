#!/bin/bash

function copyFirefoxEntrypointScript()
{
    for folder in $(ls -d ../FirefoxBrowser*); do
        cp firefox_entry_point.sh ${folder}/entry_point.sh
    done
}

function copyChromeEntrypointScript()
{
    for folder in $(ls -d ../ChromeBrowser*); do 
        cp chrome_entry_point.sh ${folder}/entry_point.sh
    done
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

function generateFirefoxMakefile()
{
    for folder in $(ls -d ../FirefoxBrowser*); do 
        source ${folder}/AutoGen.conf
        cp Makefile.template ${folder}/Makefile
        sed -i "s#%BROWSER%#${BROWSER}#g" ${folder}/Makefile
        sed -i "s#%VERSION%#${VERSION}#g" ${folder}/Makefile
    done
}

function generateChromeMakefile()
{
    for folder in $(ls -d ../ChromeBrowser*); do 
        source ${folder}/AutoGen.conf
        cp Makefile.template ${folder}/Makefile
        sed -i "s#%BROWSER%#${BROWSER}#g" ${folder}/Makefile
        sed -i "s#%VERSION%#${VERSION}#g" ${folder}/Makefile
    done
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
else
    FILES="all"
fi

COMMAND="${FOLDERS}-${FILES}"
if [ ${COMMAND} = "firefox-entrypoint" ]; then
    copyFirefoxEntrypointScript
elif [ ${COMMAND} = "firefox-dockerfile" ]; then
    generateFirefoxDockerfile
elif [ ${COMMAND} = "firefox-makefile" ]; then
    generateFirefoxMakefile
elif [ ${COMMAND} = "firefox-all" ]; then
    copyFirefoxEntrypointScript
    generateFirefoxDockerfile
    generateFirefoxMakefile
elif [ ${COMMAND} = "chrome-entrypoint" ]; then
    copyChromeEntrypointScript
elif [ ${COMMAND} = "chrome-dockerfile" ]; then
    generateChromeDockerfile
elif [ ${COMMAND} = "chrome-makefile" ]; then
    generateChromeMakefile
elif [ ${COMMAND} = "chrome-all" ]; then
    copyChromeEntrypointScript
    generateChromeDockerfile
    generateChromeMakefile
elif [ ${COMMAND} = "all-entrypoint" ]; then
    copyFirefoxEntrypointScript
    copyChromeEntrypointScript
elif [ ${COMMAND} = "all-dockerfile" ]; then
    generateFirefoxDockerfile
    generateChromeDockerfile
elif [ ${COMMAND} = "all-makefile" ]; then
    generateFirefoxMakefile
    generateChromeMakefile
else # all-all
    copyFirefoxEntrypointScript
    generateFirefoxDockerfile
    generateFirefoxMakefile
    copyChromeEntrypointScript
    generateChromeDockerfile
    generateChromeMakefile
fi

