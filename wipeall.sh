#!/bin/bash
DATA_ROOT=${DATA_ROOT:-$(pwd)}
echo "Removing containers..."
sudo docker stop $(sudo docker ps -q -f name=ethereum)
sudo ocker rm $(sudo docker ps -aq -f name=ethereum)
echo "Removing volumes in $DATA_ROOT..."
rm -Rf $DATA_ROOT/.ether-*
rm -Rf $DATA_ROOT/.bootnode
