#!/bin/bash

path1=/data/homebridge
if [ ! -d "$path1" ]; then
        sudo mkdir $path1
fi

path2=/home/pi/.firewalla/run/docker/homebridge
if [ ! -d "$path2" ]; then
        mkdir $path2
fi

TZ=$(cat /etc/timezone)

# Prompt the user with the current value pre-filled and editable.
# Note: -e enables readline, -i sets the initial value.
read -e -i "$TZ" -p "Enter your timezone and press [ENTER]: " user_input

TZ=$(cat /etc/timezone)

# Enable editable pre-filled input (requires bash, not sh)
read -e -i "$TZ" -p "Enter your timezone and press [ENTER]: " user_input

TZ=${user_input:-$TZ}

printf "\nYour timezone is: %s\n" "$TZ"


sed "s|TZ.*|TZ=${TZ}|g" $path2/docker-compose.yaml > $path2/docker-compose.yaml.tmp
mv $path2/docker-compose.yaml.tmp $path2/docker-compose.yaml

read < /dev/tty -p "Ener the port you want to run homebridge on and press [ENTER] (8080 is the default):  $port " port && port=${port:-8080}
printf "\n"
sed "s|HOMEBRIDGE_CONFIG_UI_PORT.*|HOMEBRIDGE_CONFIG_UI_PORT=${port}|g" $path2/docker-compose.yaml > $path2/docker-compose.yaml.tmp
mv $path2/docker-compose.yaml.tmp $path2/docker-compose.yaml
printf "\n\n"


cd $path2
sudo systemctl start docker
sudo docker-compose up --detach

sudo docker ps

path3=/home/pi/.firewalla/config/post_main.d

if [ ! -d "$path3" ]; then
	mkdir $path3
fi	

echo "#!/bin/bash

sudo systemctl start docker
sudo systemctl start docker-compose@homebridge " > $path3/start_homebridge.sh
sudo chmod +x $path3/start_homebridge.sh
$path3/start_homebridge.sh

echo -n "Starting docker"
while [ -z "$(sudo docker ps | grep homebridge | grep Up)" ]
do
        echo -n "."
        sleep 2s
done

sudo docker container prune -f && sudo docker image prune -fa
# sudo docker container stop homebridge && sudo docker container rm homebridge && sudo docker image rm homebridge/homebridge

echo "Done"
echo -e "Done!\n\nYou can open http://fire.walla:$port in your favorite browser and set up your Homebridge.\n\n"
