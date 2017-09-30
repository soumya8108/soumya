#!/bin/sh
sudo docker stop $(sudo docker ps -q -f name=ethereum)
sudo docker rm $(sudo docker ps -aq -f name=ethereum)
