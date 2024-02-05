#!/bin/bash

##-------------------------------------------------------------------------------##

ARCH_TYPE=$(arch)

echo $ARCH_TYPE

http_response=$(GET https://go.dev/dl/)



extracted_text=$(echo "$http_response" | grep -o -P '(?<=class="download downloadBox" href=).*?(?=>)')
echo "$extracted_text"


