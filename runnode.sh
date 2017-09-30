#!/bin/bash
IMGVERSION=$(head -n 1 .IMGVERSION)
IMGVERSION=${IMGVERSION:-"latest"}
IMGNAME=$(head -n 1 .IMGNAME)
NODE_NAME=$1
NODE_NAME=${NODE_NAME:-"node1"}
CONTAINER_NAME="ethereum-$NODE_NAME"
DATA_ROOT=${DATA_ROOT:-$(pwd)}
echo "Destroying old container $CONTAINER_NAME..."
docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME
NET_ARG=
GEN_ARG=
RPC_ARG=
RPC_PORTMAP=
UDP_PORTMAP=
#[[ ! -z $NET_ID ]] && NET_ARG="-e NET_ID=$NET_ID"
if [ ! -z $GEN_ALLOC ];then
GEN_ARG="-e GEN_ALLOC=$GEN_ALLOC"
fi
if [ ! -z $RPC_PORT ];then 
RPC_ARG='--rpc --rpcaddr=0.0.0.0 --rpcapi=db,eth,net,web3,personal --rpccorsdomain "*"' 
RPC_PORTMAP="-p $RPC_PORT:8545"
fi
if [ ! -z $UDP_PORT ];then
UDP_PORTMAP="-p $UDP_PORT:30303 -p $UDP_PORT:30303/udp"
fi
BOOTNODE_URL=${BOOTNODE_URL:-$(./getbootnodeurl.sh)}
echo "Running new container $CONTAINER_NAME..."
sudo docker run -d --name $CONTAINER_NAME \
    -v $DATA_ROOT/.ether-$NODE_NAME:/root \
    --network ethereum \
    -e "BOOTNODE_URL=$BOOTNODE_URL" \
    $NET_ARG $GEN_ARG $RPC_PORTMAP $UDP_PORTMAP \
    $IMGNAME:$IMGVERSION $RPC_ARG --identity $NODE_NAME --cache=512 --verbosity=4 --maxpeers=3 ${@:2}
