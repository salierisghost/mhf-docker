#!/bin/bash

# Env would have set this
#erupe_dir="/Erupe"
# Maybe use environment flag checking if it's installed
# Maybe use environment flag for if the user wants to redownload
erupe_repo="ZeruLight/Erupe"
erupe_url="https://github.com/${erupe_repo}"
ERUPE_VERSION="v9.1.1"

if [[ ! -e $($erupe_dir "/main.go") ]] then;
    latest_version=$(get_latest_release($erupe_repo))
    if [[ $ERUPE_VERSION == $latest_version ]] then;
        echo "There's a new version of Erupe: ${latest_version}"
    fi
    git clone --branch $ERUPE_VERSION /Erupe
fi

function get_latest_release($repo) {
    local version=$(curl --silent "https://api.github.com/repos/${erupe_repo}/releases/latest" | # Get latest release from GitHub api                                                                                                                                                                                       grep '"tag_name":' |                                            # Get tag line
    grep '"tag_name":' |
    sed -E 's/.*"([^"]+)".*/\1/')
}

exec supervisord -c /supervisord.conf