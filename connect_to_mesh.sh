#!/usr/bin/env bash

set -e

# check that we're executing with sudo
if [ "$#" -lt 1 ]; then
  echo "Usage: sudo connect_to_mesh.sh <EXITNODE_IP> [<EXITNODE_HOSTNAME>]"
  exit 1
fi

if [ ! -f connect_to_mesh.config ]
then
  echo "Could not find connect_to_mesh.config. See README.md."
  exit 1
fi

source connect_to_mesh.config

EXITNODE_IP=$1
EXITNODE_HOSTNAME=$2
EXITNODE_PORT=8942

# get the name of the default gateway
REGEX='via[[:space:]]([^[:space:]]+)[[:space:]]dev[[:space:]]([^[:space:]]+)'
TEST=$(ip route get $EXITNODE_IP)
if [[ $TEST =~ $REGEX ]]
then
  DEFAULT_GATEWAY=${BASH_REMATCH[1]}
  DEFAULT_INTERFACE=${BASH_REMATCH[2]}
else
  echo "Could not determine default interface and gateway."
  exit 1
fi

# add a static route for the exitnode via the default gateway
# (this will override the default route, which is about to become the tunnel interface l2tp0)
STATIC_ROUTE="$EXITNODE_IP/32 dev $DEFAULT_INTERFACE via $DEFAULT_GATEWAY"
echo "Adding static route $STATIC_ROUTE"
ip route add $STATIC_ROUTE

# cleanup this route when we exit the script
function cleanup {
  ip route del $STATIC_ROUTE
}
trap cleanup EXIT

# use exitnode hostname if provided
if [ -z $EXITNODE_HOSTNAME ]
then
  TUNNELDIGGER_ADDR=$EXITNODE_IP:$EXITNODE_PORT
else
  TUNNELDIGGER_ADDR=$EXITNODE_HOSTNAME:$EXITNODE_PORT
fi

echo "Connecting to $TUNNELDIGGER_ADDR..."

# open the tunnel
$TUNNELDIGGER_PATH -f -b $TUNNELDIGGER_ADDR -u $UUID -i l2tp0 -s tunnel_hook.sh &

# start babeld
$BABELD_PATH l2tp0 &

wait
