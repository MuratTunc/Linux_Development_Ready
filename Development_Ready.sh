#!/bin/bash

set -xe
mail="xxx@mail.com"
git_user_name="xxx"
apt update -y
apt-get upgrade -y
apt install curl -y
apt install build-essential -y
##-------------------------------------------------------------------------------##

apt install git -y
git config --global user.name "${git_user_name}"
git config --global user.email "${mail}"

#Personal access token
git_api_token="github_pat_xxx"

#Use the HTTPS to push a ssh key to git, SSH for pull/push configuration
gitrepo_ssh="git@github.com:xxx/xxx.git"
gitrepo_https="https://github.com/xxx/xxx"

#Generating SSH key:
ssh-keygen -f "${HOME}/.ssh/id_rsa" -t rsa -b 4096 -C "${mail}" -N ''
sslpub="$(cat ${HOME}/.ssh/id_rsa.pub |tail -1)"

eval `ssh-agent`
ssh-add ~/.ssh/id_rsa

#git API path for posting a new ssh-key:
git_api_addkey="https://api.$(echo ${gitrepo_https} |cut -d'/' -f3)/user/keys"

#lets name the ssh-key in get after the hostname with a timestamp:
git_ssl_keyname="$(hostname)_$(date +%d-%m-%Y)"

#Finally lets post this ssh key:
curl -H "Authorization: token ${git_api_token}" -H "Content-Type: application/json" -X POST -d "{\"title\":\"${git_ssl_keyname}\",\"key\":\"${sslpub}\"}" ${git_api_addkey}

##-------------------------------------------------------------------------------##
# install golang
sudo rm -rf /usr/local/go
cd Downloads/
wget https://dl.google.com/go/go1.21.5.linux-amd64.tar.gz 
sudo mv go1.21.5.linux-amd64.tar.gz /usr/local/
cd /usr/local/
sudo tar -C /usr/local/ -xzf go1.21.5.linux-amd64.tar.gz


#Add the path /usr/local/go/bin to the $PATH environment variable. Define the PATH variable in the $HOME/.profile file. You must need to restart your terminal for changes to apply.

if [ -d "/usr/local/go/bin" ] ; then
    PATH=$PATH:/usr/local/go/bin
fi

#If you are using bash, then you must also define the PATH variable in $HOME/.bashrc file, along with defining the PATH variable in the $HOME/.profile file.

if [ -d "/usr/local/go/bin" ] ; then
    PATH=$PATH:/usr/local/go/bin
fi

go version



