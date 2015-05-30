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
    copyFirefoxEntrypointScript
elif [ ${COMMAND} = "firefox-dockerfile" ]; then
    generateFirefoxDockerfile
elif [ ${COMMAND} = "firefox-makefile" ]; then
    generateFirefoxMakefile
elif [ ${COMMAND} = "firefox-readme" ]; then
    generateFirefoxReadme
elif [ ${COMMAND} = "firefox-all" ]; then
    copyFirefoxEntrypointScript
    generateFirefoxDockerfile
    generateFirefoxMakefile
    generateFirefoxReadme
elif [ ${COMMAND} = "chrome-entrypoint" ]; then
    copyChromeEntrypointScript
elif [ ${COMMAND} = "chrome-dockerfile" ]; then
    generateChromeDockerfile
elif [ ${COMMAND} = "chrome-makefile" ]; then
    generateChromeMakefile
elif [ ${COMMAND} = "chrome-readme" ]; then
    generateChromeReadme
elif [ ${COMMAND} = "chrome-all" ]; then
    copyChromeEntrypointScript
    generateChromeDockerfile
    generateChromeMakefile
    generateChromeReadme
elif [ ${COMMAND} = "all-entrypoint" ]; then
    copyFirefoxEntrypointScript
    copyChromeEntrypointScript
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
    copyFirefoxEntrypointScript
    generateFirefoxDockerfile
    generateFirefoxMakefile
    copyChromeEntrypointScript
    generateChromeDockerfile
    generateChromeMakefile
    generateFirefoxReadme
    generateChromeReadme
fi

