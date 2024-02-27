#!/bin/bash

slp=2 #sleep constant in seconds
##-------------------------------------------------------------------------------##
#Color variables.
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
magenta='\033[0;35m'
cyan='\033[0;36m'
clear='\033[0m'

readUserConfigFileParameters() {

    source config.txt
    echo -e "${green}-->Status:User Input Parameters... ${clear}!"
    echo -e "${green}-->Status:mail=$mail ... ${clear}!"
    echo -e "${green}-->Status:git_user_name=$git_user_name ... ${clear}!"    
}

initialize() {
    clear
}

updatesystem() {

    echo -e "${green}-->Status:Updating and linux system... ${clear}!"
    apt update -y
    sleep ${slp}
    echo -e "${green}-->Status:Install curl... ${clear}!"
    sleep ${slp}
    apt install curl -y
    echo -e "${green}-->Status:essential... ${clear}!"
    sleep ${slp}
    apt install build-essential -y
}

installVSCode() {
    echo -e "${green}-->Status:Installing VS Code...${clear}!"
    echo -e "${green}-->Status:Remove current VS Code from machine...${clear}!"
    apt autoremove code -y
    rm -rf ~/.vscode ~/.config/Code
    echo -e "${green}-->Status:Installing VS Code...${clear}!"
    echo -e "${green}-->Status:Remove current VS Code from machine...${clear}!"
    apt autoremove code -y
    rm -rf ~/.vscode ~/.config/Code
    echo -e "${green}-->Status:Getting Latest debian package VS Code from repo ...${clear}!"
    apt install software-properties-common apt-transport-https wget -y
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
    add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" -"\n"
    apt install code
    vs_code_version=$(code --version)
    echo -e "${green}-->Status:Installed VS Code $vs_code_version ...${clear}!"
}

installGit() {
    echo -e "${green}-->Status:Installing git ... ${clear}!"
    sleep ${slp}
    apt install git -y
    git config --global user.name "${git_user_name}"
    git config --global user.email "${mail}"
    sleep ${slp}

    #Generating SSH key
    ssh-keygen -f "${HOME}/.ssh/id_rsa" -t rsa -b 4096 -C "${mail}" -N '' -y
    sslpub="$(cat ${HOME}/.ssh/id_rsa.pub |tail -1)"
    sleep ${slp}
    eval `ssh-agent`
    sleep ${slp}
    ssh-add ~/.ssh/id_rsa
    sleep ${slp}
}

installGoLang() {
    echo -e "${green}-->Status:Installing GoLang...${clear}!"
    echo -e "${green}-->Status:Getting latest go version tar file from web source...${clear}!"
    http_response=$(GET https://go.dev/dl/)
    extracted_response=$(echo "$http_response" | grep -o -P '(?<=class="download downloadBox" href=).*?(?=>)')
    go_version_full=$(echo "$extracted_response" | grep "linux" )
    len=${#go_version_full}
    go_version=${go_version_full:5:len-6}
    echo -e "${green}-->Status:Latest golang linux tar file: ${go_version} ...${clear}!"

    echo -e "${green}-->Status:Removing old go tar files from /usr/local... ${clear}!"
    rm -rf /usr/local/go
    rm -rf /usr/local/go_version
    rm -rf go_version
    sleep ${slp}
    echo -e "${green}-->Status:Downloading go version ${go_version}... ${clear}!"
    wget https://dl.google.com/go/${go_version}

    sleep ${slp}
    mv ${go_version} /usr/local/
    cd /usr/local/
    echo -e "${green}-->Status:Untar downloaded ${go_version} file... ${clear}!"
    sleep ${slp}
    tar -C /usr/local/ -xzf ${go_version}
    sleep ${slp}
    
    #Add the path /usr/local/go/bin to the $PATH environment variable.(profile)
    echo -e "${green}-->Status:EXPORT PATH variable to profile... ${go_version}... ${clear}!"
    sleep ${slp}
    export PATH=$PATH:/usr/local/go/bin
    sleep ${slp}
    source ~/.profile
    sleep ${slp}
    echo -e "${green}-->go version...$(go version) ${clear}!"
}

installPostgresgl() {

    echo -e "${green}-->Status:Installing postgres... ${clear}!"
    sleep ${slp}
    sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
    sleep ${slp}
    apt-get install postgresql -y
    export PATH=/usr/lib/postgresql/16/bin:$PATH
    sleep ${slp}
    source ~/.profile
}

processEnd() {
    echo -e "${green}-->Status:Process ENDED !... ${clear}!"
}

initialize
readUserConfigFileParameters
updatesystem
installVSCode
installGit
installGoLang
installPostgresgl
processEnd
