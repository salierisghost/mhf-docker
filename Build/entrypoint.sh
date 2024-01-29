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
ERUPE_URL="${ERUPE_GIT}/releases/download/${ERUPE_VERSION}/Linux-amd64.zip"         # Compiled binary
ERUPE_CHECK_URL="https://api.github.com/repos/${ERUPE_REPO}/releases/latest"
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
    echo "URL: $url"
    local extension="${url##*.}"
    local target="$2"
    echo "Target: $target"
    local tmpPath="/tmp/file.zip"
    echo "/tmp path: $tmpPath"

    curl --location "$url" --output "$tmpPath"
    7za x -y "$tmpPath" -o"$target"

    rm "$tmpPath"
    echo "Extracted $url"
}

function main() {

    # Check to see if there's a newer version and log it
    get_latest_release
    latest_version="$?"
    if [[ $ERUPE_VERSION == $latest_version ]]; then
        echo "There's a new version of Erupe: ${latest_version}"
    fi

    if [[ ! -e $("${ERUPE_DIR}/erupe-ce") ]]; then
        echo "Downloading new repo"
        #download_and_unzip "$ERUPE_URL" "${ERUPE_DIR}/."
        #download_and_unzip "$ERUPE_BINARY_REPO_URL" "${ERUPE_DIR}"
        prep_install
    else
        echo "Found existing repo"
    fi

    /usr/bin/supervisord -c /supervisord.conf
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

function prep_install() {
    mkdir "$ERUPE_DIR/logs"
    chmod 770 "$ERUPE_DIR/erupe-ce"
    #prep_config
}

function prep_database() {
    psql -U "$ERUPE_DB_USERNAME" -d erupe -f "$ERUPE_DIR/bundled-schema/*" -W
}

function prep_config() {
    # Modifying server IP address with selected IP
    sed --regexp-extended 's/"Host": "127.0.0.1",/"Host": "$ERUPE_HOST"/' $ERUPE_DIR/config.json

    # Modify database credentials
    sed "s/\"Host\": \"localhost",/\"Host\": \"$ERUPE_DB_HOST\"/" $ERUPE_DIR/config.json
    sed "s/\"User\": \"postgres",/"User": "$ERUPE_DB_USERNAME"/' $ERUPE_DIR/config.json
    sed "s/\"Password\": \"\",/"Password": "$ERUPE_DB_PASSWORD"/' $ERUPE_DIR/config.json
    sed "s/\"Database\": \"erupe\",/"Password": "$ERUPE_DB_NAME"/' $ERUPE_DIR/config.json
}

main
