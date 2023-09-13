#!/bin/bash
# Created by https://github.com/WafflesExploit/WafflesExploit
<<description
# Extracts Java 8 to /usr/lib/jvm/jdk1.8.0_381 and Installs it.
# Link: https://www.oracle.com/java/technologies/downloads/
description

lightgreen=`echo -en "\e[92m"`
lightyellow=`echo -en "\e[93m"`
lightblue=`echo -en "\e[94m"`
white=`echo -en "\e[97m"`
aqua=`echo -en "\e[36m"`
green=`echo -en "\e[32m"`
orange=`echo -en "\e[33m"`

if [[ $1 == "-h" || $1 == "" ]]; then
	echo "./installjdk8.sh [PathToFile]"
	echo " Example: /home/kali/Downloads/jdk-8u381-linux-x64.tar.gz"
	exit
fi

Java_extract_file=$1


dir=/usr/lib/jvm
if [ -d $dir ]; then # If /usr/lib/jvm exits cd into it
    cd $dir
else # If not, create it then cd into it
    sudo mkdir $dir 
    cd $dir
fi

echo "${lightblue}->Moved to /usr/lib/jvm${white}"

fieldcount=$(tr -dc '/' <<< $Java_extract_file | wc -c)
fieldnum=$(expr $fieldcount + 1)
output=$(cut -d "/" -f $fieldnum <<< $Java_extract_file)
output="$(echo $output | grep -P -o "\-8u\d+\-" | cut -d "u" -f 2 | tr -d "-")"

jdk_dir="/usr/lib/jvm/jdk1.8.0_$output"
if [ -d $jdk_dir ]; then # Removes the jdk-15.0.2 folder if he finds it
    sudo rm -r "$jdk_dir"
    echo "Removed $jdk_dir."
fi

sudo tar -xzvf $Java_extract_file





cd $jdk_dir

echo "${lightgreen}->Extracted Java 8 to $jdk_dir."
echo "${orange}Add the following to the end of PATH variable inside of /etc/environment:"
echo "${white}:$jdk_dir/bin:$jdk_dir/jre/bin"
echo ""
echo "${lightblue}Example: ${white}PATH=/usr/local/sbin:$jdk_dir/bin:$jdk_dir/jre/bin"
