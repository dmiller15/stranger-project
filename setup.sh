#!/bin/bash

# Make ephemeral storage user-assessible
sudo chown ubuntu:ubuntu /mnt

mkdir -p ~/.duck/profiles/
cp osdc.cyberduckprofile ~/.duck/profiles
