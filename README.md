## connect_to_mesh.sh

This is a convenience tool for connecting your home computer to the mesh through an exitnode. It uses babeld and tunneldigger, just like a home node, so it's useful for testing and debugging exitnodes when you don't have access to a home node.

This script has been tested on Debian Stretch.

#### Dependencies

You need to install [babeld](https://github.com/jech/babeld) and [tunneldigger](https://github.com/wlanslovenija/tunneldigger/).

#### Create a config file

You'll need a tool that generates uuids, like `uuidgen`. Then you can do:

```
./create_config.sh $(uuidgen) > connect_to_mesh.config
```

Have a look at the `connect_to_mesh.config` file you just created. It should look something like:

```
# this will be your computer's mesh ip address
MESH_IP=<some-mesh-ip-address-here>

# tunneldigger identifies you with this id
UUID=<some-uuid-here>

# the location of the tunneldigger client executable
TUNNELDIGGER_PATH=../tunneldigger/client/tunneldigger

# the location of the babeld executable
BABELD_PATH=babeld
```

Edit the `TUNNELDIGGER_PATH` and `BABELD_PATH` variables by hand if you need to.

#### Connect

Now you can connect to any exitnode you want to:

```
sudo ./connect-to-mesh.sh <exitnode-ip-address>
```

You have to use sudo because `connect_to_mesh.sh` uses the `ip` command and `babeld`. And you must execute the script from the root of the repo directory because it uses some relative paths.

Example output:

```
sudo ./connect_to_mesh.sh 208.70.31.83
Adding static route 208.70.31.83/32 dev wlp1s0 via 10.12.10.1
Connecting to 208.70.31.83:8942...
td-client: Performing broker selection...
td-client: Broker usage of 208.70.31.83:8942: 63
td-client: Selected 208.70.31.83:8942 as the best broker.
td-client: Tunnel successfully established.
send: Cannot assign requested address
td-client: Setting MTU to 1446
td-client: Setting MTU to 1446
```