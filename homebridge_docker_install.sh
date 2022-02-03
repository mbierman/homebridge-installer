#!/bin/bash 

path1=/data/homebridge
if [ ! -d "$path1" ]; then
        sudo mkdir $path1
fi

path2=/home/pi/.firewalla/run/docker/homebridge/
if [ ! -d "$path2" ]; then
        mkdir $path2
fi

curl https://raw.githubusercontent.com/mbierman/homebridge-installer/main/docker-compose.yml \
> $path2/docker-compose.yaml

cd $path2

sudo systemctl start docker
sudo docker-compose up --detach

sudo docker ps

echo -n "Starting docker"
while [ -z "$(sudo docker ps | grep unifi | grep Up)" ]
do
        echo -n "."
        sleep 2s
done
echo "Done"


path3=/home/pi/.firewalla/config/post_main.d
if [ ! -d "$path3" ]; then
        mkdir $path3
fi

echo "#!/bin/bash
sudo systemctl start docker
sudo systemctl start docker-compose@unifi
sudo ipset create -! docker_lan_routable_net_set hash:net
sudo ipset add -! docker_lan_routable_net_set 172.16.1.0/24
sudo ipset create -! docker_wan_routable_net_set hash:net
sudo ipset add -! docker_wan_routable_net_set 172.16.1.0/24" >  /home/pi/.firewalla/config/post_main.d/start_unifi.sh

chmod a+x /home/pi/.firewalla/config/post_main.d/start_unifi.sh

sudo docker stop unifi
sudo docker start unifi

echo -n "Restarting docker"
while [ -z "$(sudo docker ps | grep unifi | grep Up)" ]
do
        echo -n "."
        sleep 2s
done

sudo docker container prune -f && sudo docker image prune -fa
# sudo docker container stop homebridge && sudo docker container rm homebridge && sudo docker image rm oznu/homebridge

echo -e "Done!\n\nYou can open https://fire.walla:8581/ in your favorite browser and set up your Homebridge.\n\n"
