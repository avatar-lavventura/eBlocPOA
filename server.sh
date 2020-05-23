#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/config.sh

# Updates peers
git fetch 2>/dev/null
git checkout origin/master -- peers.js 2>/dev/null
git checkout origin/master -- custom.json 2>/dev/null

# Ensure running as root
if [ "$(id -u)" != "0" ]; then
    echo "E: Please run: sudo ./server.sh";
    exit
fi

if [ -z "$DATADIR" ]
then
    echo "E: Fill DATADIR variable in config.sh. You can run ./initialize.sh"
    exit
fi

PORT=3000;

pid=$(sudo lsof -n -i :$PORT | grep LISTEN| awk '{print $2}');
if [ -n "$pid" ]; then
  sudo kill -9 $pid
fi

nohup geth --syncmode fast --cache=1024 --shh --datadir /private --port $PORT \
      --rpcaddr 127.0.0.1 --rpc --rpcport 8545 --rpccorsdomain="*" --networkid 23422 \
      --rpcapi admin,eth,net,web3,debug,personal,shh --targetgaslimit '10000000' \
      --gasprice "18000000000" --allow-insecure-unlock> $DATADIR/geth_server.out &

SLEEP_DURATION=15;
echo "Please wait $SLEEP_DURATION seconds for geth-server to be activated before adding peers.
You can decrease the sleep duration in the server.sh script."
sleep $SLEEP_DURATION # Sleep for few seconds for geth-server to be activated, otherwise peers won't added.

echo "loadScript(\"$DATADIR"/peers.js"\")" | sudo geth --datadir "/private" attach ipc:/private/geth.ipc console
echo "loadScript(\"$DATADIR"/pass.js"\")"  | sudo geth --datadir "/private" attach ipc:/private/geth.ipc console
echo "net"                                 | sudo geth --datadir "/private" attach ipc:/private/geth.ipc console

bash stats.sh
sudo chown $(whoami) /private/geth.ipc
