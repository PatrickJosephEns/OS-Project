#!/bin/bash
setPassword() {
    username=$1

    if [[ $username == "root" ]]; then
        password="cowperso"
    elif [[ $username == "bill" ]]; then
        password="P@ssw0rd"
    elif [[ $username == "ozalp" ]]; then
        password="12ucdort"
    elif [[ $username == "sklower" ]]; then
        password="theik!!!"
    elif [[ $username == "kridle" ]]; then
        password="jilland1"
    elif [[ $username == "kurt" ]]; then
        password="sacristy"
    elif [[ $username == "schmidt" ]]; then
        password="wendy!!!"
    elif [[ $username == "hpk" ]]; then
        password="graduat"
    elif [[ $username == "tbl" ]]; then
        password="pnn521"
    elif [[ $username == "jfr" ]]; then
        password="5%ghj"
    elif [[ $username == "mark" ]]; then
        password="uio"
    elif [[ $username == "dmr" ]]; then
        password="dmac"
    elif [[ $username == "ken" ]]; then
        password="p/q2-q4!"
    elif [[ $username == "sif" ]]; then
        password="axolot1"
    elif [[ $username == "scj" ]]; then
        password="pdq;dq"
    elif [[ $username == "pjw" ]]; then
        password="uucpuucp"
    elif [[ $username == "bwk" ]]; then
        password="/.,/.,"
    elif [[ $username == "uucp" ]]; then
        password="whatnot"
    elif [[ $username == "srb" ]]; then
        password="bourne"
    elif [[ $username == "mckusick" ]]; then
        password="foobar"
    elif [[ $username == "peter" ]]; then
        password="...hello"
    elif [[ $username == "henry" ]]; then
        password="sn74193n"
    elif [[ $username == "jkf" ]]; then
        password="sherril."
    elif [[ $username == "fateman" ]]; then
        password="apr1744"
    elif [[ $username == "fabry" ]]; then
        password="561cm1.."
    else 
        password="P@ssw0rd"
    fi

    echo "Setting password to $password"
    echo "Setting password username to $username"
    echo "$username:$password" | sudo chpasswd
    if [[ $? == 0 ]]; then
        echo "Password has successfully been set for $username"
        chage -d 0 $username
    else
        echo "Password is not set for $username"
    fi
}
    
dpath="$1"

#http://kate.ict.op.ac.nz/~faisalh/IN616osc/legends.txt

#If the users hasn't put any arguments
if [ -z "$1" ]; then
    echo "Please enter the file source path or link:"
    read dpath
fi  

#if the arguments is a link based file
if [[ $dpath == "http"* ]]; then
    wget $dpath
    if [[ $? == 0 ]]; then
        echo "Successfully downloaded file."
        #grabs the basename of the link which should be
        #legends.txt
        dpath=$(basename "$dpath")
    else
        echo "Unsuccessfully downloaded file."
        exit 1
    fi
else
#checks if the local file exists
    if [[ ! -f $dpath ]];then
        echo "Local file does not exist."
        exit 1
    else
        echo "Found file $dpath ..."
    fi
fi


echo "About to create `wc -l $dpath` users"
read -p "Are you sure? " -n 1 -r

if [[ $REPLY =~ ^[Yy]$ ]]; then
    #create shared folder requirements
    sudo mkdir -p /shared
    sudo groupadd shared
    sudo chgrp shared /shared
    sudo chmod 640 /shared
    sudo mkdir /usr/staff

    while IFS=: read -r username password uid gid name groups directory preferedshell; do 
    if id -u $username >/dev/null 2>&1; then
        echo "$username already exists ... Skipping user."
    else

        if [ ! -d "$directory" ]; then
          mkdir $directory
        fi
        
        if [[ -z "$groups" ]];then
          groups=shared
        fi
        
        if [[ -z "$preferedshell" ]];then
          preferedshell=/bin/bash
        fi
        
        echo "=========================="
        echo "Adding user $username ..."
        echo "Groups: $groups,shared"
        echo "Directory: $directory"
        echo "Shell: $preferedshell"
        sudo useradd -G $groups,shared -d $directory $username -s $preferedshell
        if [[ $? == 0 ]]; then
            echo "Account has been created for $username"
            setPassword $username
            #sudo chmod 755 $directory
            ln -s /shared $directory
        else
            echo "Error creating user $username"
        fi
        echo "========================"
    fi
    done < $dpath

fi

