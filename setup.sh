#!/bin/bash

# Setup proxy
echo \
'export no_proxy="griffin-objstore.opensciencedatacloud.org"
function with_proxy() {
     PROXY="http://cloud-proxy:3128"
     http_proxy="${PROXY}" https_proxy="${PROXY}" $@
}' >> ~/.bashrc && source ~/.bashrc

# Make ephemeral storage user-assessible
sudo chown ubuntu:ubuntu /mnt

# Add deb repos for CRAN and duck
sudo echo 'deb http://cran.case.edu/bin/linux/ubuntu trusty/' >> /etc/apt/sources.list.d/sources.list
sudo echo 'deb https://s3.amazonaws.com/repo.deb.cyberduck.io stable main' >> /etc/apt/sources.list.d/sources.list

# Add key for CRAN
with_proxy sudo -E apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E084DAB9

# Add key for duck.sh
with_proxy sudo -E apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys FE7097963FEFBE72

# Update packages
with_proxy sudo -E apt-get update
with_proxy sudo -E apt-get install r-base duck

mkdir -p ~/.duck/profiles/
cp ~/osdc-docs/osdc.cyberduckprofile ~/.duck/profiles
