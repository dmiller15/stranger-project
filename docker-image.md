# Creating a docker image from the stock ubuntu image

Following the instructions from here:

https://docs.docker.com/v1.8/installation/ubuntulinux/

First configure the proxy:

```
echo \
'export no_proxy="bionimbus-objstore.opensciencedatacloud.org"
function with_proxy() {
     PROXY="http://cloud-proxy:3128"
     http_proxy="${PROXY}" https_proxy="${PROXY}" $@
}' >> ~/.bashrc && source ~/.bashrc
```

Add the GPG key

`with_proxy curl -sSL https://get.docker.com/gpg | sudo apt-key add -`

Run the install script

`with_proxy curl -sSL https://get.docker.com/ | sh`

You might have to wait for it to try to download the GPG key AgentForwarding

Check to see if docker installed successfully

`sudo docker version`

Configure user settings

Add user to docker group to run docker commands without root

`sudo usermod -aG docker ubuntu`

Configure the docker proxy

Edit the `/etc/default/docker` file and edit the HTTP_PROXY line to be `bionimbus-objstore.opensciencedatacloud.org`

Reload the docker service

`sudo service docker restart`
