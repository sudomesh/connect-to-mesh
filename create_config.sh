UUID=$1
# Generate a random mesh ip in the 100.120.0.0/16 range.
# This range is large enough that it is unlikely to collide with
# other people using this script. This range is also towards the
# end of the mesh subnet 100.64.0.0/10, so it won't collide
# with any existing nodes (for now). 
MESH_IP=100.120.$(( $RANDOM % 255 )).$(( $RANDOM % 255 ))

echo "# this will be your computer's mesh ip address"
echo "MESH_IP=$MESH_IP"
echo ""
echo "# tunneldigger identifies you with this id"
echo "UUID=$UUID"
echo ""
echo "# the location of the tunneldigger client executable"
echo "TUNNELDIGGER_PATH=../tunneldigger/client/tunneldigger"
echo ""
echo "# the location of the babeld executable"
echo "BABELD_PATH=babeld"
