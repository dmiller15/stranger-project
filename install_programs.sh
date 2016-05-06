#!/bin/bash

# invoke with sudo

sudo echo 'deb http://cran.case.edu/bin/linux/ubuntu trusty/' >> /etc/apt/sources.list.d/sources.list
sudo echo 'deb https://s3.amazonaws.com/repo.deb.cyberduck.io stable main' >> /etc/apt/sources.list.d/sources.list

# Add key for CRAN
with_proxy sudo -E apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E084DAB9

# Add key for duck.sh
with_proxy sudo -E apt-key adv --keyserver hpk://keyserver.ubuntu.com:80 --recv-keys FE7097963FEFBE72

# Update packages
with_proxy sudo -E apt-get update
with_proxy sudo -E apt-get install r-base duck