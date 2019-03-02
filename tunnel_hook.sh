#!/usr/bin/env bash

source connect_to_mesh.config

sudo ip link set l2tp0 up
sudo ip addr add $MESH_IP dev l2tp0
