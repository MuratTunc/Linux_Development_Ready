#!/bin/bash

##-------------------------------------------------------------------------------##
slp=2 #sleep constant in sceconds
##-------------------------------------------------------------------------------##
#Color variables.
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
magenta='\033[0;35m'
cyan='\033[0;36m'
clear='\033[0m'
##-------------------------------------------------------------------------------##
# Clear the screen
clear
echo -e "${green}-->Status:installing golang... ${clear}!"
sleep ${slp}
rm -rf /usr/local/go
echo -e "${green}-->Status:Downloading go version ${go_version}... ${clear}!"

http_response=$(GET https://go.dev/dl/)
extracted_response=$(echo "$http_response" | grep -o -P '(?<=class="download downloadBox" href=).*?(?=>)')
go_version_full=$(echo "$extracted_response" | grep "linux" )
len=${#go_version_full}
go_version=${go_version_full:5:len-6}
wget https://dl.google.com/go/${go_version}

sleep ${slp}
mv ${go_version} /usr/local/
cd /usr/local/
echo -e "${green}-->Status:untar downloaded file... ${go_version}... ${clear}!"
sleep ${slp}
tar -C /usr/local/ -xzf ${go_version}
sleep ${slp}

#Add the path /usr/local/go/bin to the $PATH environment variable.(profile)

echo -e "${blue}-->Status:EXPORT PATH variable to profile... ${go_version}... ${clear}!"
sleep ${slp}
echo -e "\n# Path added by my personal installer" >> ~/.profile
echo "[ -d /usr/local/go/bin ] && PATH=\"/usr/local/go/bin:\$PATH\"" >> ~/.profile
sleep ${slp}
source ~/.profile
sleep ${slp}
echo -e "${green}-->go version... ${clear}!"
go version