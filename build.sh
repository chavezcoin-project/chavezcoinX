#!/bin/bash

set -e

date
ps axjf

#################################################################
# Update Ubuntu and install prerequisites for running Chavezcoin   #
#################################################################
sudo apt-get update
#################################################################
# Build Chavezcoin from source                                     #
#################################################################
NPROC=$(nproc)
echo "nproc: $NPROC"
#################################################################
# Install all necessary packages for building Chavezcoin           #
#################################################################
sudo apt-get install -y qt4-qmake libqt4-dev libminiupnpc-dev libdb++-dev libdb-dev libcrypto++-dev libqrencode-dev libboost-all-dev build-essential libboost-system-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libssl-dev libdb++-dev libssl-dev ufw git
sudo add-apt-repository -y ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get install -y libdb4.8-dev libdb4.8++-dev

cd /usr/local
file=/usr/local/chavezcoinX
if [ ! -e "$file" ]
then
        sudo git clone https://github.com/chavezcoin-project/chavezcoinX.git
fi

cd /usr/local/chavezcoinX/src
file=/usr/local/chavezcoinX/src/chavezcoind
if [ ! -e "$file" ]
then
        sudo make -j$NPROC -f makefile.unix
fi

sudo cp /usr/local/chavezcoinX/src/chavezcoind /usr/bin/chavezcoind

################################################################
# Configure to auto start at boot                                      #
################################################################
file=$HOME/.chavezcoin
if [ ! -e "$file" ]
then
        sudo mkdir $HOME/.chavezcoin
fi
printf '%s\n%s\n%s\n%s\n' 'daemon=1' 'server=1' 'rpcuser=u' 'rpcpassword=p' | sudo tee $HOME/.chavezcoin/chavezcoin.conf
file=/etc/init.d/chavezcoin
if [ ! -e "$file" ]
then
        printf '%s\n%s\n' '#!/bin/sh' 'sudo chavezcoind' | sudo tee /etc/init.d/chavezcoin
        sudo chmod +x /etc/init.d/chavezcoin
        sudo update-rc.d chavezcoin defaults
fi

/usr/bin/chavezcoind
echo "Chavezcoin has been setup successfully and is running..."
exit 0

