#!/bin/bash

##-------------------------------------------------------------------------------##

http_response=$(GET https://go.dev/dl/)
extracted_response=$(echo "$http_response" | grep -o -P '(?<=class="download downloadBox" href=).*?(?=>)')
go_version_full=$(echo "$extracted_response" | grep "linux" )
len=${#go_version_full}
go_version=${go_version_full:5:len-6}
wget https://dl.google.com/go/${go_version}