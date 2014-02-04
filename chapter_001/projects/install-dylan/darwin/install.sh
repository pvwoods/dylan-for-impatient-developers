#!/bin/sh
curl -O http://opendylan.org/downloads/opendylan/2013.2/opendylan-2013.2-x86-darwin.tar.bz2
tar -xvzf opendylan-2013.2-x86-darwin.tar.bz2
sudo mv opendylan-2013.2 /opt/
echo "export PATH=/opt/opendylan-2013.2/bin:$PATH" >> ~/.bashrc
source ~/.bashrc
