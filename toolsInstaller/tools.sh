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

help(){
    echo "${white} usage: tools.sh [-h] [ [-a ALL] [-p PRIVESC] [-u UTIL] [-i INSDES] [-o OTHERS] [-f FIX] ] "
    echo ""
    echo "${white}-> Downloads Tools & Installs Dependecies/Fixes."
    echo ""
    echo "options:"
    echo "-h, --help       Show this help message and exit."
    echo "-a, --all        Runs all operations [privesc, util, fix, insdes, others]."
    echo "-p, --privesc    Downloads privesc tools."
    echo "-u, --util       Downloads utility scripts."
    echo "-i, --insdes     Downloads insecure deserialization tools." 
    echo "-o, --others     Downloads/Installs others tools. Ex: haiti, cook..."
    echo "-f, --fix        Installs dependecies & fixes."
    exit 1
}
privesc=false
util=false
fix=false
others=false
insdes=false

if [[ $1 == '-h' || $1 == '--help' ]]; then
    help
elif [[ $1 == '-a' || $1 == '--all' ]]; then
    privesc=true
    util=true
    fix=true
    others=true
    insdes=true
elif [[ $1 == '-p' || $1 == '--privesc' ]]; then
    privesc=true
elif [[ $1 == '-u' || $1 == '--util' ]]; then
    util=true
elif [[ $1 == '-f' ||  $1 == '--fix' ]]; then
    fix=true
elif [[ $1 == '-i' || $1 == '--insdes' ]]; then
    insdes=true
elif [[ $1 == '-o' || $1 == '--others' ]]; then
    others=true
else
    help
fi

echo "${lightyellow}------Waffles' Downloads------"

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

fileDownload(){
    Value=$1
    File=$2
    Outputfile=$3
    fdots 1
    echo -n "${lightblue}-> Downloading $File."
    wget -q -O $Outputfile $Value; chmod +x $Outputfile
    fdots 0
}

DownloadGithub(){
    # unset GitTools, and then create new elements for it.
    for key in "${!GitTools[@]}"; do
        val="${GitTools[$key]}"
        file=$key
        key=$(echo "$key" | cut -d "_" -f 1)
        
        fieldcount=$(tr -dc '/' <<< $val | wc -c)
        fieldnum=$(expr $fieldcount + 1)
        output=$(cut -d "/" -f $fieldnum <<< $val)

    check=$(echo $output | grep -i -c ".zip") # If the output is .zip
    if [ $check == 1 ];then
        if [ -d $key ]; then
            rm $key -r
        fi
        mkdir 'temp'
        cd 'temp'
        
        fileDownload $val $file $output

        mv $output $key.zip
        output=$key.zip
        echo "${lightgreen}-> Created $output"
        fdots 1
        echo -n "${lightblue}-> Extracting $output"
        unzip -qq -o $output
        rm $key.zip
        fdots 0
        dir=$(ls | grep ".")
        if [ -d $dir ]; then
            mv $dir $key
            mv $key ../$key
            cd ..
            rm 'temp' -r
        else
            cd ..
            mv 'temp' $key
        fi
        echo "${lightgreen}-> Extracted $output to $key-master"
    else # If not
        if [ -d $key ]; then
            cd $key
        else
            mkdir $key
            cd $key
        fi
        fileDownload $val $file $output
        cd ..
    fi
    done
}

InstallImpacket(){
    fdots 1
    echo -n "${lightblue}-> Downloading & Installing Impacket"
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
        InstallImpacket
    else
        echo "${orange}-> Impacket already installed"
    fi
}

InstallGolang(){
    fdots 1
    echo -n "${lightblue}-> Installing & Fixing Go"
    gotoInitialDIR
    chmod +x fixgolang.sh
    ./fixgolang.sh 
    echo "${lightgreen}-> Installed Go"
    fdots 0
}
CheckforGolang(){ # Checks if go is installed
    check=$(whereis go  | grep -i -c "/usr/bin/go")
    if [ $check -ne 1 ]; then
        InstallGolang
    else
        echo "${orange}-> Golang already installed"
    fi
}
CheckIfInstalled(){
    toolname=$1
    toollocation=$2
    command=$3
    check=$(whereis $toolname  | grep -i -c "$toollocation")
    if [ $check -ne 1 ]; then
        fdots 1
        echo -n "${lightblue}-> Installing $toolname"
        eval "$command" 1>/dev/null
        fdots 0
        echo "${lightgreen}-> Installed $toolname"
    else
        echo "${orange}-> $toolname already installed"
    fi
}
InstallCook(){
    toolname="cook"
    toollocation="/usr/bin/cook"
    check=$(whereis $toolname  | grep -i -c "$toollocation")
    if [ $check -ne 1 ]; then
        fdots 1
        echo -n "${lightblue}-> Installing $toolname"
        go install -v github.com/glitchedgitz/cook/v2/cmd/cook@latest 2>/dev/null
        cd ~/go/bin
        sudo mv cook /usr/bin/cook
        cook 2>/dev/null
        fdots 0
        echo "${lightgreen}-> Installed $toolname"
    else
        echo "${orange}-> $toolname already installed"
    fi
}
InstallOtherTools(){
    CheckIfInstalled "haiti" "/usr/local/bin/haiti" "sudo gem install haiti-hash"
    InstallCook

}
# ***************************
# **** Dependecies/Fixes ****
# ***************************

if [ $fix == true ]; then 
    echo "${lightyellow}------Dependecies/Fixes----"

    echo "${white}This script needs sudo to install dependencies/fixes, so write your password in the following prompt:"
    sudo echo "${white}Successfully entered sudo."

    CheckforGolang

    CheckforImpacket

    echo "${lightyellow}------Finished------"
    echo ""
fi

gotoInitialDIR
cd .. # Leaves Folder /toolsInstaller

# **********************
# **** Script Start ****
# **********************

# ** PrivEsc/Start/ **
if [ $privesc == true ]; then
    echo "${lightyellow}------Download Tools------"

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
fi
# ** PrivEsc/End/ **

gotoInitialDIR
cd .. # Leaves Folder /toolsInstaller

# ** Insecure Deserialization/Start/ **
if [ $insdes == true ]; then
    unset GitTools # Clear the elements of GitTools
    # Remember to leave a space character, after the URL. 
    # Remember, to make files stay in the same folder use "_" Example: <foldername>_<filetype> -> winPEAS_bat
    # If you don't have a download link, view the file as raw, and use that link. Example: https://raw.githubusercontent.com/example.sh/
    declare -A GitTools 
    GitTools[ysoserial-JAVA]="https://github.com/frohoff/ysoserial/releases/download/v0.0.6/ysoserial-all.jar "
    GitTools[ysoserial-NET]="https://github.com/pwntester/ysoserial.net/releases/download/v1.35/ysoserial-1.35.zip "
    GitTools[PHPGGC-PHP]="https://github.com/ambionics/phpggc/archive/refs/heads/master.zip "
    folderCheck 'Insecure_Deserialization'

    DownloadGithub
fi
# ** Insecure Deserialization/End/ **

gotoInitialDIR
cd .. # Leaves Folder /toolsInstaller

# ** UtilScripts/Start/ **
if [ $util == true ]; then
    folderCheck 'UtilScripts'
    unset GitTools # Clear the elements of GitTools
    # Remember to leave a space character, after the URL. 
    # Remember, to make files stay in the same folder use "_" Example: <foldername>_<filetype> -> winPEAS_bat
    # If you don't have a download link, view the file as raw, and use that link. Example: https://raw.githubusercontent.com/example.sh/
    declare -A GitTools 
    GitTools[PimpMyKali]="https://raw.githubusercontent.com/Dewalt-arch/pimpmykali/master/pimpmykali.sh "

    DownloadGithub
fi
# ** UtilScripts/End/ **

gotoInitialDIR
cd .. # Leaves Folder /toolsInstaller

# ** Other Tools/Start/ **
if [ $others == true ]; then
    InstallOtherTools
fi
# ** Other Tools/End/**

gotoInitialDIR
cd .. # Leaves Folder /toolsInstaller

echo "${lightyellow}------Finished all Downloads------"
echo "${lightyellow}------Finished Running------------"
