#!/bin/bash 
  
echo Running installer
read -p "Do you want to continue? (y|n) ? " -n 1 -r

if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo su -
        systemctl stop docker-compose@*
        systemctl stop docker
        cd /var/lib/docker/
        rm -rf overlay2/*
        systemctl start docker
        sudo docker system prune -a
else
        echo -e  "\n\nOk then.\n\n"
fi

exit
