#!/bin/bash
fix_golang() {
    section="golang"  #check this golang or golang-go?
    check=$(whereis go  | grep -i -c "/usr/bin/go")
    fix_section $section $check $force
    fix_go_path
    }

fix_section() {
    if [ $check -ne 1 ]
        then
        # sanity check : force=0 check=0 or force=1 check=0
        echo -e "\n  $greenplus install : $section"
        eval apt -o Dpkg::Progress-Fancy="1" -y install $section $silent
        elif [ $force = 1 ]
        then
        # sanity check : force=1 check=1
        echo -e "\n  $redstar reinstall : $section"
        eval apt -o Dpkg::Progress-Fancy="1" -y reinstall $section $silent
        else
        # sanity check : force=0  check=1
        echo -e "\n  $greenminus $section already installed"
        echo -e "       use --force to reinstall"
    fi
    check=""
    type=""
    section=""
}

fix_go_path() {
    # added gonski fix - 01.21.22 rev 1.4.2
    # --- This needs to be moved to a Global from a local as it is reused at line 1165 ---
    # Why am I not using $finduser here?
    check_for_displayzero=$(who | grep -c "(\:0)")
    if [ $check_for_displayzero == 1 ]
     then
      findrealuser=$(who | grep "(\:0)" | awk '{print $1}')
      echo -e "\n  $greenplus getting user from display 0 (:0) : $findrealuser"
    else
      findrealuser=$(who | grep "tty[0-9]" | sort -n | head -n1 | awk '{print $1}')
      echo -e "\n  $greenplus display0 not found getting user from tty : $findrealuser"
    fi
     # above is the Gonski Fix, Gonski was getting 'kali kali' in $findrealuser the original "who | awk '{print $1}'" statement
     # with a kali user on tty7 (:0) and then kali pts/1, as pimpmykali.sh is being run with sudo and was producing this fault
     # this will resolve the issue either logged into x11 on display 0 or just in a terminal on a tty
     # --- Move the above to a global from a local as it is reused on line 1165 ----
    if [ $findrealuser == "root" ]
     then
      check_root_zshrc=$(cat /root/.zshrc | grep -c GOPATH)
      [ -d /$findrealuser/go ] && echo -e "\n  $greenminus go directories already exist in /$findrealuser" || echo -e "\n  $greenplus creating directories /$findrealuser/go /$findrealuser/go/bin /$findrealuser/go/src"; mkdir -p /$findrealuser/go/{bin,src}
       if [ $check_root_zshrc -ne 0 ]
         then
          echo -e "\n  $redminus GOPATH Variables for $findrealuser already exist in /$findrealuser/.zshrc - Not changing"
         else
          echo -e "\n  $greenplus Adding GOPATH Variables to /root/.zshrc"
          eval echo -e 'export GOPATH=\$HOME/go' >> /root/.zshrc
          eval echo -e 'export PATH=\$PATH:\$GOPATH/bin' >> /root/.zshrc
       fi
      check_root_bashrc=$(cat /root/.bashrc | grep -c GOPATH)
       if [ $check_root_bashrc -ne 0 ]
        then
         echo -e "\n  $redminus GOPATH Variables for $findrealuser already exist in /$findrealuser/.bashrc - Not changing"
        else
         echo -e "\n  $greenplus Adding GOPATH Variables to /root/.bashrc"
         eval echo -e 'export GOPATH=\$HOME/go' >> /root/.bashrc
         eval echo -e 'export PATH=\$PATH:\$GOPATH/bin' >> /root/.bashrc
       fi
     else
      check_user_zshrc=$(cat /home/$findrealuser/.zshrc | grep -c GOPATH)
       [ -d /home/$findrealuser/go ] && echo -e "\n  $greenminus go directories already exist in /home/$finduser" || echo -e "\n  $greenplus creating directories /home/$findrealuser/go /home/$findrealuser/go/bin /home/$findrealuser/go/src"; mkdir -p /home/$findrealuser/go/{bin,src}; chown -R $findrealuser:$findrealuser /home/$findrealuser/go
       if [ $check_user_zshrc -ne 0 ]
        then
         echo -e "\n  $redminus GOPATH Variables for user $findrealuser already exist in /home/$findrealuser/.zshrc  - Not Changing"
        else
         echo -e "\n  $greenplus Adding GOPATH Variables to /home/$findrealuser/.zshrc"
         eval echo -e 'export GOPATH=\$HOME/go' >> /home/$findrealuser/.zshrc
         eval echo -e 'export PATH=\$PATH:\$GOPATH/bin' >> /home/$findrealuser/.zshrc
       fi
      check_user_bashrc=$(cat /home/$findrealuser/.bashrc | grep -c GOPATH)
       if [ $check_user_bashrc -ne 0 ]
        then
         echo -e "\n  $redminus GOPATH Variables for user $findrealuser already exist in /home/$findrealuser/.bashrc - Not Changing"
        else
         echo -e "\n  $greenplus Adding GOPATH Variables to /home/$findrealuser/.bashrc"
         eval echo -e 'export GOPATH=\$HOME/go' >> /home/$findrealuser/.bashrc
         eval echo -e 'export PATH=\$PATH:\$GOPATH/bin' >> /home/$findrealuser/.bashrc
       fi
    fi
}

fix_golang
