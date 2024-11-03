# Install Homebridge Docker Container on Firewalla Gold, Gold SE, Gold Pro or Purple

This is a script for installing the [Homebridge docker container](https://github.com/oznu/docker-homebridge) on Firewalla Gold or Purple. It should get you up and running. It is based on the [Firewalla tutorial](https://help.firewalla.com/hc/en-us/articles/360053184374-Guide-Install-HomeBridge-on-Firewalla-).

To install, [learn how to ssh into your firewalla](https://help.firewalla.com/hc/en-us/articles/115004397274-How-to-access-Firewalla-using-SSH-) if you don't know how already.

Note: One user reported that the latest homebridge isn't working with firewallas running Ubuntu 18.x. If you want to run Homebridge on firewalla, I recommend flashing to the latest
* [Purple/Purple SE](https://help.firewalla.com/hc/en-us/articles/4407636001555-Resetting-Firewalla-Purple-Purple-SE#h_01FGJZDHFVJAZ93W64KMERS22R)
* [Gold SE](https://help.firewalla.com/hc/en-us/articles/19523706861843)
* [Gold/Gold Plus](https://help.firewalla.com/hc/en-us/articles/360048626153-Firewalla-Gold-and-Gold-Plus-How-to-Flash-Installer-Image)
* [Gold Pro](https://help.firewalla.com/hc/en-us/articles/30466076408467-Firewalla-Gold-Pro-How-to-Flash-Installer-Image)


Beyond that, all you need to know to get this running is how to copy/paste.

Next, copy the line below and paste into the Firewalla shell and then hit Return. 

 ```
 curl -s -L -C- https://raw.githubusercontent.com/mbierman/homebridge-installer/main/homebridge_docker_install.sh | cat <(cat <(bash))
```

**Standard disclaimer:** I can not be responsible for any issues that may result. Nothing in the script should in any way, affect firewalla as a router or comprimise security. Happy to answer questions though if I can. :)

# What is Homebridge?

> Homebridge is a lightweight NodeJS server you can run on your home network that emulates the iOS HomeKit API. It supports Plugins, which are community-contributed modules that provide a basic bridge from HomeKit to various 3rd-party APIs provided by manufacturers of "smart home" devices.

>Since Siri supports devices added through HomeKit, this means that with Homebridge you can ask Siri to control devices that don't have any support for HomeKit at all."

# Why run homebridge on Firewalla?
You can run Homebridge on lots of devices. If you don't have a NAS or Raspberry Pi around, and you are a <a href="https://firewalla.com">Fireawlla</a> user, you can run it right on your Firewalla appliance. You can use this for all the usual homebridge things, but most interesting to me was to monitor Firewalla's own stats. You also get dashboard readings about CPU load and memory consumption: 

<img width="1253" alt="image" src="https://user-images.githubusercontent.com/1205471/163029657-83b49c2e-fae8-4c55-94ed-8e1ec66b0ba3.png">

And the CPU temperatures:
![image](https://user-images.githubusercontent.com/1205471/163027786-7d2168f7-0392-4fff-9e67-42a69cd5a069.png)

Now you can see Firewalla's temperature as a homekit sensor. To fully configure this for Firewalla specifically, see the  [Firewalla guide](https://help.firewalla.com/hc/en-us/articles/360053184374-Guide-Install-HomeBridge-on-Firewalla-).

# Updating docker
[Here's a script](https://gist.github.com/mbierman/6cf22430ca0c2ddb699ac8780ef281ef) for updating docker containers.

# Restarting after Firewalla update or reboot
[Here's a script](https://gist.github.com/mbierman/1d0fceaea979f17ca65f1599fb1ebbbb) for restarting Homebridge after reboots and FW upgrades. 

# Uninstalling

If you need to reset the container (stop and remove and try again) run the following commands.

WARNING: if you use these commands you are stopping and removing the container. Don't do this unless you are sure that you don't mind potentially losing your homebridge configuration. If you haven't managed to get the Controller running then there is probably no harm in this: nothing to lose.

Otherwise, only do this if you know at least a little bit about what you are doing. And always backup.

```
# This stops the homebridge container and removes it to get you back to a clean state.
sudo docker update --restart=no homebridge && sudo docker stop homebridge 
sudo docker container rm homebridge
cd /home/pi/.firewalla/run/docker/homebridge && sudo docker-compose down
sudo docker image rm -f ubuntu/homebridge
sudo rm -f /home/pi/.firewalla/run/docker/homebridge/docker-compose.yaml && \
sudo rm -rf /data/homebridge /home/pi/.firewalla/run/docker/homebridge
sudo docker system prune -af
```

You can also use the `resetdocker.sh` script to reset docker to a prestine state. 

There are lots of homebridge communities on [Reddit](https://www.reddit.com/r/homebridge/) and [discord](https://discord.com/channels/432663330281226270/432671265774632961). If you have homebridge questions, please check there. 
