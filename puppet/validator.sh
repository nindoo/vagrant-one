#!/bin/bash
mkdir ~/validator
cd ~/validator
sudo apt-get install openjdk-6-jdk
export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
hg clone https://bitbucket.org/validator/build build
python build/build.py all
python build/build.py all