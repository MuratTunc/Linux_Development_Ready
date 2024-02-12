#!/bin/bash

##-------------------------------------------------------------------------------##
set -xe
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

mail="xxx@mail.com"
git_user_name="xxx"

##-------------------------------------------------------------------------------##
#update-upgrade.
echo -e "${blue}-->Status:Updating and Upgraiding system... ${clear}!"
apt update -y
sleep ${slp}
echo -e "${blue}-->Status:Install curl... ${clear}!"
sleep ${slp}
apt install curl -y
echo -e "${blue}-->Status:essential... ${clear}!"
sleep ${slp}
apt install build-essential -y

##-------------------------------------------------------------------------------##
echo -e "${blue}-->Status:install git... ${clear}!"
sleep ${slp}
apt install git -y
git config --global user.name "${git_user_name}"
git config --global user.email "${mail}"
sleep ${slp}

#You should enter your access token to here.
git_api_token="github_pat_xxx"

#Use the HTTPS to push a ssh key to git, SSH for pull/push configuration
gitrepo_ssh="git@github.com:xxx/xxx.git"
gitrepo_https="https://github.com/xxx/xxx"

#Generating SSH key:
ssh-keygen -f "${HOME}/.ssh/id_rsa" -t rsa -b 4096 -C "${mail}" -N ''
sslpub="$(cat ${HOME}/.ssh/id_rsa.pub |tail -1)"
sleep ${slp}
eval `ssh-agent`
sleep ${slp}
ssh-add ~/.ssh/id_rsa
sleep ${slp}

#git API path for posting a new ssh-key:
git_api_addkey="https://api.$(echo ${gitrepo_https} |cut -d'/' -f3)/user/keys"
git_ssl_keyname="$(hostname)_$(date +%d-%m-%Y)"

echo -e "${blue}-->Status:post ssh key... ${blue}${clear}!"
curl -H "Authorization: token ${git_api_token}" -H "Content-Type: application/json" -X POST -d "{\"title\":\"${git_ssl_keyname}\",\"key\":\"${sslpub}\"}" ${git_api_addkey}
sleep ${slp}

##-------------------------------------------------------------------------------##
echo -e "${blue}-->Status:installing golang... ${clear}!"
sleep ${slp}
rm -rf /usr/local/go
cd Downloads/
echo -e "${blue}-->Status:Downloading go version ${go_version}... ${clear}!"

http_response=$(GET https://go.dev/dl/)
extracted_response=$(echo "$http_response" | grep -o -P '(?<=class="download downloadBox" href=).*?(?=>)')
go_version_full=$(echo "$extracted_response" | grep "linux" )
len=${#go_version_full}
go_version=${go_version_full:5:len-6}
wget https://dl.google.com/go/${go_version}

sleep ${slp}
mv go1.21.5.linux-amd64.tar.gz /usr/local/
cd /usr/local/
echo -e "${blue}-->Status:untar downloaded file... ${go_version}... ${clear}!"
sleep ${slp}
tar -C /usr/local/ -xzf ${go_version}
sleep ${slp}


##-------------------------------------------------------------------------------##
#Add the path /usr/local/go/bin to the $PATH environment variable.
echo -e "${blue}-->Status:EXORT PATH variable to profile... ${go_version}... ${clear}!"
sleep ${slp}
echo -e "\n# path added by my personal installer" >> ~/.profile
echo "[ -d /usr/local/go/bin ] && PATH=\"/usr/local/go/bin:\$PATH\"" >> ~/.profile
source ~/.profile
sleep ${slp}

##-------------------------------------------------------------------------------##
#Add the path /usr/local/go/bin to the $PATH environment variable.
echo -e "${blue}-->Status:EXORT PATH variable to bashrc... ${go_version}... ${clear}!"
sleep ${slp}
echo -e "\n# path added by my personal installer" >> ~/.profile
echo "[ -d /usr/local/go/bin ] && PATH=\"/usr/local/go/bin:\$PATH\"" >> ~/.bashrc
source ~/.bashrc
sleep ${slp}

##-------------------------------------------------------------------------------##
#install postgreSQL
echo -e "${blue}-->Status:installing postgres... ${clear}!"
sleep ${slp}
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
sleep ${slp}
apt-get install postgresql -y

##-------------------------------------------------------------------------------##
echo -e "${green}-->Status:Process ENDED !... ${clear}!"
