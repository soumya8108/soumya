#!/bin/bash
ENODE_LINE=$(sudo docker logs ethereum-bootnode 2>&1 | grep enode | head -n 1)
echo "enode:${ENODE_LINE#*enode:}"

