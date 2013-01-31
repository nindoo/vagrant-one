#!/bin/bash
wget \
  -c http://download.virtualbox.org/virtualbox/4.0.8/VBoxGuestAdditions_4.0.8.iso \
  -O VBoxGuestAdditions_4.0.8.iso
sudo mount VBoxGuestAdditions_4.0.8.iso -o loop /mnt
sudo sh /mnt/VBoxLinuxAdditions.run --nox11
rm *.iso

# http://till.klampaeckel.de/blog/archives/155-VirtualBox-Guest-Additions-and-vagrant.html