#!/bin/bash
# Downloads Tools for privilege escalation.
# Created by WafflesExploit



# ******************************
# **** Functions and colors ****
# ******************************

lightgreen=`echo -en "\e[92m"`
lightyellow=`echo -en "\e[93m"`
lightblue=`echo -en "\e[94m"`
white=`echo -en "\e[97m"`
aqua=`echo -en "\e[36m"`
green=`echo -en "\e[32m"`
orange=`echo -en "\e[33m"`

initialdir=$(pwd)

echo "${lightyellow}------Waffles' Downloads------"


if [[ $1 == '-h' ]]; then
        echo "${white}-$ ./tools.sh "
        echo "${white}-> Downloads Tools for privilege escalation."
        exit 0
fi

gotoInitialDIR(){
    cd $initialdir
}

dots(){ # Echoes dots to be used inside of the fuction fdots
 while true; do
 	echo -ne "."
 	sleep 0.5
 done
}
pid=a
fdots(){ # Used to display dots as a visual indicator when an operation is in progress.
	if [[ $1 == 1 ]]; then
		dots &
		pid=$!
	else
		kill $pid
		echo ""	
	fi
}

folderCheck(){ # Checks if folder exists, if not creates one. After the check it cd to the folder.
    # First argument needs to be the name of the folder in string format.
	folder=$1
	if [[ ! (-d $folder) ]]; then
	mkdir $folder
	echo "${green}${folder} created"
	
	else
		echo "${orange}${folder} already created"
	fi
	echo "${aqua}Moving in to ${folder}"
	cd $folder
}
declare -A GitTools

DownloadGithub(){
    # unset GitTools, and then create new elements for it.
    for key in "${!GitTools[@]}"; do
        val="${GitTools[$key]}"
        key=$(echo "$key" | cut -d "_" -f 1)
        if [ -d $key ]; then
            cd $key
        else
            mkdir $key
            cd $key
        fi
        fieldcount=$(tr -dc '/' <<< $val | wc -c)
        fieldnum=$(expr $fieldcount + 1)
        output=$(cut -d "/" -f $fieldnum <<< $val)
        
        if [ -f $output ]; then
        if [ $output == "master.zip" ];then
            rm $key.zip
            rm $key -r
        fi
        rm $output
        fi
        
        echo -n "${lightblue}-> Downloading $key."
        fdots 1
        wget -q $val; chmod +x $output
        fdots 0
        if [ $output == "master.zip" ];then
            mv master.zip $key.zip
            output=$key.zip
            echo "${lightgreen}-> Created $output"
            if [ -d "$key-master" ]; then
                rm $key-master -r
            fi
            fdots 1
            echo -n "${lightblue}-> Extracting $key.zip"
            unzip -qq $output
            rm $key.zip
            fdots 0
            echo "${lightgreen}-> Extracted $key.zip to $key-master"
        else
            echo "${lightgreen}-> Created $output"
        fi
        cd ..
        
    done
}

InstallImpacket(){
    echo "${lightblue}-> Downloading & Installing Impacket"
    fdots 1
    sudo apt install pipx 1>/dev/null
    python3 -m pipx install impacket 1>/dev/null
    pipx ensurepath 1>/dev/null
    fdots 0
    echo "${lightgreen}-> Installed Impacket"
    echo "${orange}-> To use impacket use impacket-[scriptName]"
    
}
CheckforImpacket(){
    check=$(whereis impacket  | grep -i -c "/usr/share/impacket")
    if [ $check -ne 1 ]; then
        echo "${lightblue}->Installing & Fixing Impacket"
        InstallImpacket
        echo "${lightgreen}-> Installed Impacket"
    else
        echo "${orange}-> Impacket already installed"
    fi
}

InstallGolang(){
    fdots 1
    gotoInitialDIR
    chmod +x fixgolang.sh
    ./fixgolang.sh 
    fdots 0
}
CheckforGolang(){ # Checks if go is installed
    check=$(whereis go  | grep -i -c "/usr/bin/go")
    if [ $check -ne 1 ]; then
        echo "${lightblue}->Installing & Fixing Go"
        InstallGolang
        echo "${lightgreen}-> Installed Go"
    else
        echo "${orange}-> Golang already installed"
    fi
}

# ***************************
# **** Dependecies/Fixes ****
# ***************************

echo "${lightyellow}------Dependecies/Fixes----"

echo "${white}This script needs sudo to install dependencies/fixes, so write your password in the following prompt:"
sudo echo "${white}Successfully entered sudo."

CheckforGolang

CheckforImpacket

gotoInitialDIR

echo "${lightyellow}------Finished------"
echo ""


# *************************
# **** Start of Script ****
# *************************
echo "${lightyellow}------Download Tools------"

cd .. # Leaves Folder /toolsInstaller


folderCheck 'PrivEscTools'


# ** LinPriv/Start/ **
folderCheck 'LinPriv'

unset GitTools # Clear the elements of GitTools
# Remember to leave a space character, after the URL. 
# Remember, to make files stay in the same folder use "_" Example: <foldername>_<filetype> -> winPEAS_bat
# If you don't have a download link, view the file as raw, and use that link. Example: https://raw.githubusercontent.com/example.sh/
declare -A GitTools 
GitTools[LinPEAS]="https://github.com/carlospolop/PEASS-ng/releases/download/20230425-bd7331ea/linpeas.sh "
GitTools[LinEnum]="https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh "
GitTools[linux-exploit-suggester]="https://raw.githubusercontent.com/The-Z-Labs/linux-exploit-suggester/master/linux-exploit-suggester.sh "
GitTools[Linux-smart-enumeration]="https://github.com/diego-treitos/linux-smart-enumeration/releases/download/4.11nw/lse.sh "

DownloadGithub
# ** LinPriv/End/ **


cd .. # Move to /PrivEscTools folder.


# ** WinPriv/Start/ **
unset GitTools # Clear the elements of GitTools
# Remember to leave a space character, after the URL. 
# Remember, to make files stay in the same folder use "_" Example: <foldername>_<filetype> -> winPEAS_bat
# If you don't have a download link, view the file as raw, and use that link. Example: https://raw.githubusercontent.com/example.sh/
declare -A GitTools 
GitTools[winPEAS_bat]="https://github.com/carlospolop/PEASS-ng/releases/download/20230425-bd7331ea/winPEAS.bat "
GitTools[winPEAS_x64exe]="https://github.com/carlospolop/PEASS-ng/releases/download/20230425-bd7331ea/winPEASx64.exe "
GitTools[winPEAS_x86exe]="https://github.com/carlospolop/PEASS-ng/releases/download/20230425-bd7331ea/winPEASx86.exe "
GitTools[PowerUp]="https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/master/Privesc/PowerUp.ps1 "
GitTools[Windows-Exploit-Suggester]="https://raw.githubusercontent.com/bitsadmin/wesng/master/wes.py "
GitTools[Sherlock]="https://raw.githubusercontent.com/rasta-mouse/Sherlock/master/Sherlock.ps1 "
GitTools[Watson]="https://github.com/rasta-mouse/Watson/archive/refs/heads/master.zip "
GitTools[JAWS]="https://raw.githubusercontent.com/411Hall/JAWS/master/jaws-enum.ps1 "
GitTools[Seatbelt]="https://github.com/GhostPack/Seatbelt/archive/refs/heads/master.zip "
GitTools[SharpUp]="https://github.com/GhostPack/SharpUp/archive/refs/heads/master.zip "


folderCheck 'WinPriv'

DownloadGithub
# ** WinPriv/End/ **


cd .. # Move to /PrivEscTools.

cd .. # Move to initial folder.


# ** UtilScripts/Start/ **
folderCheck 'UtilScripts'
unset GitTools # Clear the elements of GitTools
# Remember to leave a space character, after the URL. 
# Remember, to make files stay in the same folder use "_" Example: <foldername>_<filetype> -> winPEAS_bat
# If you don't have a download link, view the file as raw, and use that link. Example: https://raw.githubusercontent.com/example.sh/
declare -A GitTools 
GitTools[PimpMyKali]="https://raw.githubusercontent.com/Dewalt-arch/pimpmykali/master/pimpmykali.sh "

DownloadGithub
# ** UtilScripts/End/ **



echo "${lightyellow}------Finished all Downloads------"
echo "${lightyellow}------Finished Running------------"
