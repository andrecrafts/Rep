#!/bin/bash
# Created by WafflesExploit
# Downloads Java 15 and extract it to /usr/lib/jvm/jdk-15.0.2
cd ~/Downloads
wget -O openjdk-15.0.2_linux-x64_bin.tar.gz 'https://download.java.net/java/GA/jdk15.0.2/0d1cfde4252546c6931946de8db48ee2/7/GPL/openjdk-15.0.2_linux-x64_bin.tar.gz'
dir=/usr/lib/jvm
if [ -d $dir ]; then # If /usr/lib/jvm exits cd into it
    cd $dir
else # If not, create it then cd into it
    sudo mkdir $dir 
    cd $dir
fi

echo "Moved to /usr/lib/jvm"

jdk_dir="/usr/lib/jvm/jdk-15.0.2"
if [ -d $jdk_dir ]; then # Removes the jdk-15.0.2 folder if he finds it
    sudo rm $jdk_dir -r
fi

sudo tar -xzvf ~/Downloads/openjdk-15.0.2_linux-x64_bin.tar.gz
cd jdk-15.0.2

echo "Extracted Java 15 to $jdk_dir."
echo "Add :$jdk_dir the end of PATH variable inside of /etc/environment"
echo ""
echo "Example: PATH=/usr/local/sbin:$jdk_dir"
