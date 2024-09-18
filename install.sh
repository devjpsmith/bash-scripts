#!/bin/bash

# great for docker image that needs node installed!

cyan='\033[0;36m'
green='\033[0;32m'
red='\033[0;31m'
yellow='\033[0;33m'
gray='\033[0;37m'
bold='\033[1m'
nc='\033[0m'
check=✅
cross=❌

log() {
    local message=$1
    local level=$2

    case $level in
        "info")
            echo -e "${cyan}[INFO]\t${message}${nc}"
            ;;
        "debug")
            echo -e "${green}[DEBUG]\t${message}${nc}"
            ;;
        "error")
            echo -e "${red}[ERROR]\t${cross} ${message}${nc}"
            ;;
        "warning")
            echo -e "${yellow}[WARN]\t${message}${nc}"
            ;;
        "success")
            echo -e "${green}[PASS]\t${check} ${nc}${bold}${message}${nc}"
            ;;
        *)
            echo -e "${message}"
            ;;
    esac
}

update() {
    log "Updating local environment..." "info"
    if ! apt-get update -y ; then
        log "Failed to update local repository." "error"
        exit 1
    fi

    if ! apt-get upgrade -y; then
        log "Failed to upgrade local repository." "error"
        exit 1
    fi

    if ! apt install -y curl; then
        log "Failed to install curl." "error"
        exit 1
    fi
    log "Local environment updated successfully." "success"
}

getNode() {
    log "Getting installation script for NodeJS 21.x..." "info"
    curl -sLk -o /app/nodesource_setup.sh https://deb.nodesource.com/setup_21.x
    
    if ! sh /app/nodesource_setup.sh; then
        log "Failed to get installation script for NodeJS 21.x." "error"
        exit 1
    fi

    log "Installing NodeJS..." "info"
    if ! apt-get install nodejs -y; then
        log "Failed to install NodeJS and NPM." "error"
        exit 1
    fi

    checkNodeVersion
    log "NodeJS installed successfully." "success"
    
}

checkNodeVersion() {
    version=$(node -v)
    if [[ "${version:0:3}" = "v21" ]]; then
        log "NodeJS version is ${version:0:3}" "info"
    else
        log "NodeJS version ${version:0:3} is not 21.x." "error"
        exit 1
    fi
}

log "Beginning Installation..." "info"
update
getNode
log "Installation Complete!" "info"
