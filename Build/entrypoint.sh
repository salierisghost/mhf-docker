#!/bin/bash

# Env would have set this
ERUPE_DIR="/Erupe"
echo $ERUPE_DIR
# Maybe use environment flag checking if it's installed.
# Maybe use environment flag for if the user wants to redownload.
# All of these should be overwritten environment vars.
ERUPE_REPO="ZeruLight/Erupe"                                                                    # Default Repo
ERUPE_GIT="https://github.com/${ERUPE_REPO}"                                                    # Change this if they ever leave Github
ERUPE_VERSION="v9.2.0"                                                                          # Latest version as of 13/12/20231
ERUPE_URL=("$ERUPE_GIT" "$ERUPE_REPO" "/releases/download" "$ERUPE_VERSION" "/Linux-amd64.zip") # Compiled binary
ERUPE_CHECK_URL="https://api.github.com/repos/$ERUPE_REPO/releases/latest"
ERUPE_BINARY_REPO_URL="https://files.catbox.moe/xf0l7w.7z"                                      # From the Erupe repo

echo $ERUPE_REPO
echo $ERUPE_GIT
echo $ERUPE_VERSION
echo $ERUPE_URL
echo $ERUPE_BINARY_REPO_URL

function get_latest_release() {
    local version=$(curl --silent $ERUPE_CHECK_URL | # Get latest release from GitHub api                                                                                                                                                                                       grep '"tag_name":' |                                     # Get tag line
    grep '"tag_name":' |
    sed -E 's/.*"([^"]+)".*/\1/')
    echo $version
}

function download_and_unzip() {
    local url="$1"
    local target="$2"
    local tmpPath="/tmp/file.zip"

    curl "$binUrl" --output "$tmpPath"
    unzip "$tmpPath" "$target"

    rm "$tmpPath"
}

function main() {

    # Check to see if there's a newer version and log it
    get_latest_release
    latest_version="$?"
    if [[ $ERUPE_VERSION == $latest_version ]]; then
        echo "There's a new version of Erupe: ${latest_version}"
    fi

    if [[ ! -e $("$ERUPE_DIR/erupe-ce") ]]; then
        download_and_unzip "$ERUPE_URL" "$ERUPE_DIR"
        download_and_unzip "$ERUPE_BINARY_REPO_URL" "$ERUPE_DIR/bin"
    fi
}

#if [[ ! -e $($ERUPE_DIR "/main.go") ]]; then
#    mkdir "$ERUPE_DIR/downloads"
#    get_latest_release "$ERUPE_REPO"
#    latest_version=$?
#    if [[ $ERUPE_VERSION == $latest_version ]]; then
#        echo "There's a new version of Erupe: ${latest_version}"
#    fi
#    git clone --branch $ERUPE_VERSION $ERUPE_URL /Erupe
#
#    download_and_unzip "$ERUPE_BINARY_REPO_URL" "$ERUPE_DIR/bin"
#fi



exec supervisord -c /supervisord.conf
