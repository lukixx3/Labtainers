#!/bin/bash
read -p "This script will reboot the system when done, press enter to continue"
ln -s trunk/scripts/labtainer-student
cd trunk/setup_scripts
found_distrib=`cat /etc/*-release | grep "^DISTRIB_ID" | awk -F "=" '{print $2}'`
if [[ -z "$1" ]]; then
    distrib=$found_distrib
else
    distrib=$1
fi
RESULT=0
case "$distrib" in
    Ubuntu)
        echo is ubuntu
        RESULT=$(./install-docker-ubuntu.sh)
        ;;
    Debian)
        echo is debian
        RESULT=$(./install-docker-debian.sh)
        ;;
    Fedora)
        echo is fedora
        RESULT=$(./install-docker-fedora.sh)
        ;;
    Centos)
        echo is centos
        RESULT=$(./install-docker-centos.sh)
        ;;
    *)
        if [[ -z "$1" ]]; then
            echo "Did not recognize distribution: $found_distrib"
            echo "Try providing distribution as argument, either Ubuntu|Debian|Fedora|Centos"
        else
            echo $"Usage: $0 Ubuntu|Debian|Fedora|Centos"
        fi
        exit 1
esac
if [[ "$RESULT"==0 ]]; then
    /usr/bin/newgrp docker <<EONG
    /usr/bin/newgrp $USER <<EONG
    docker pull mfthomps/labtainer.base
EONG
    sudo reboot
fi
