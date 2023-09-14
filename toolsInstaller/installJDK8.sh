#!/bin/bash
# Extracts and Installs Java 8 for Kali Linux to /usr/lib/jvm/jdk1.8.0_381 and Installs it.
# Link: https://www.oracle.com/java/technologies/downloads/


lightgreen=`echo -en "\e[92m"`
lightyellow=`echo -en "\e[93m"`
lightblue=`echo -en "\e[94m"`
white=`echo -en "\e[97m"`
aqua=`echo -en "\e[36m"`
green=`echo -en "\e[32m"`
orange=`echo -en "\e[33m"`

if [[ $1 == "-h" || $1 == "" ]]; then
	echo "./installjdk8.sh [PathToFile]"
    echo " -> Extracts and Installs Java 8 for Kali Linux"
    echo " Example: ./installjdk8.sh /home/kali/Downloads/jdk-8u381-linux-x64.tar.gz"
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
javapath=":$jdk_dir/bin:$jdk_dir/jre/bin"

echo "${lightgreen}->Extracted Java 8 to $jdk_dir."
oldpath=$(cat /etc/environment | grep "PATH.*")
check=$(cat /etc/environment | grep "PATH.*" | grep -i -c -P ":/usr/lib/jvm/jdk1.8.0_\d*/bin:/usr/lib/jvm/jdk1.8.0_\d*/jre/bin:?")
if [ $check == 1 ]; then
    pathToReplace=$(echo $oldpath | grep "PATH.*" | grep -i -o -P ":/usr/lib/jvm/jdk1.8.0_\d*/bin:/usr/lib/jvm/jdk1.8.0_\d*/jre/bin:?")    
    sedstring='s\'$pathToReplace'\\'
    sudo sed -i $sedstring /etc/environment
    oldpath=$(cat /etc/environment | grep "PATH.*")
    newpath="$oldpath$javapath"
    sedstring='s\'$oldpath'\'$newpath'\'
    sudo sed -i $sedstring /etc/environment
else
    newpath="$oldpath$javapath"
    sedstring='s\'$oldpath'\'$newpath'\'
    sudo sed -i $sedstring /etc/environment 
fi

echo "${lightgreen}->Added '$javapath' to PATH."

silent=$(sudo update-alternatives --install "/usr/bin/java" "java" "$jdk_dir/bin/java" 0)
silent=$(sudo update-alternatives --install "/usr/bin/java" "java" "$jdk_dir/bin/javac" 0)
silent=$(sudo update-alternatives --set java $jdk_dir/bin/java)
silent=$(sudo update-alternatives --set java $jdk_dir/bin/javac)
up_al_output=$(echo | sudo update-alternatives --config java) 
numToSelect=$(echo $up_al_output | grep -o -P "\d+\s+/usr/lib/jvm/jdk1.8.0_381/bin/java\s" | cut -d " " -f 1)
action=$(echo $numToSelect | sudo update-alternatives --config java)

echo "${lightyellow}->Java 1.8.0_$output has been successfully installed :)"
