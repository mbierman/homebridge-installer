# Install Homebridge Docker Container on Firewalla Gold or Purple

This is a script for installing the [Homebridge docker container](https://github.com/oznu/docker-homebridge) on Firewalla Gold or Purple. It should get you up and running. It is based on the [Firewalla tutorial](https://help.firewalla.com/hc/en-us/articles/360053184374-Guide-Install-HomeBridge-on-Firewalla-).

To install, [learn how to ssh into your firewalla](https://help.firewalla.com/hc/en-us/articles/115004397274-How-to-access-Firewalla-using-SSH-) if you don't know how already.

Beyond that, all you need to know to get this running is how to copy/paste.

Next, copy the line below and paste into the Firewalla shell and then hit Return. 

 ```
 curl -s -L -C- https://raw.githubusercontent.com/mbierman/homebridge-installer/main/homebridge_docker_install.sh | cat <(cat <(bash))
```

**Standard disclaimer:** I can not be responsible for any issues that may result. Nothing in the script should in any way, affect firewalla as a router or comprimise security. Happy to answer questions though if I can. :)

# What is Homebridge?

> Homebridge is a lightweight NodeJS server you can run on your home network that emulates the iOS HomeKit API. It supports Plugins, which are community-contributed modules that provide a basic bridge from HomeKit to various 3rd-party APIs provided by manufacturers of "smart home" devices.

>Since Siri supports devices added through HomeKit, this means that with Homebridge you can ask Siri to control devices that don't have any support for HomeKit at all."

# Why would you want homebridge on Firewalla?
You can run Homebridge on lots of devices. If you don't have a NAS or Raspberry Pi around Fireawlla is an alternative. But most interesting is to monitor Firewalla's temperature. 

![image](https://user-images.githubusercontent.com/1205471/163027786-7d2168f7-0392-4fff-9e67-42a69cd5a069.png)

Now you can see Firewalla's temperature as a homekit sensor. 


# Uninstalling

If you need to reset the container (stop and remove and try again) run the following commands.

WARNING: if you use these commands you are stopping and removing the container. Don't do this unless you are sure that you don't mind potentially losing stuff. If you haven't managed to get the Controller running then there is probably no harm in going forward. Otherwise, only do this if you know at least a little bit about what you are doing. And always backup.

```
sudo docker-compose down && sudo docker container stop homebridge && sudo docker container rm homebridge && sudo docker image rm oznu/homebridge && sudo docker system prune && sudo systemctl stop docker
rm /home/pi/.firewalla/config/post_main.d/start_homebridge.sh
```

There are lots of homebridge communities on [Reddit](https://www.reddit.com/r/homebridge/) and [discord](https://discord.com/channels/432663330281226270/432671265774632961). If you have homebridge questions, please check there. 
