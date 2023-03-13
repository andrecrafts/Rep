#!/bin/bash
echo '------Text To File------'
if [[ -z "$1" ]] || [[ -z "$2" ]]; then
	echo '$ ttf.sh <text> <file>'
	echo 'Creates/Overwrites text to a file.' 
	exit 0
fi
echo "$1" > $2
echo "$2 Has been created."
