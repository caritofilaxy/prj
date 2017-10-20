#!/bin/bash

#ping -c 2 github.com >/dev/null 
#if [ $? -ne 0 ]; then
#	echo "Github unavailable";
#	exit;
#fi

git add .
git commit -m '-'
git push
