#!/bin/bash
######################################
# Configuration
######################################
BR_START="bitcoind"
BITCOIN_CLI="bitcoin-cli"

DATA_DIR="-datadir=/home/richard/Documents/regtest-peers/peers/"

DAEMON="-daemon"
STOP="-stop"
BR_OPTS="-printtoconsole -externalip=127.0.0.1"

SLEEP_TIME=7

LOG_FILE="/tmp/bitcoind.log"
PID_FILE="/tmp/bitcoind.pid"

PEERS_DIR="bitcoin-regtest-node/peers"
REGTEST_DIR="${HOME}/.bitcoin/regtest/"

DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LIB_DIR=${DIR}/lib

######################################
# Include dependencies
######################################
source ${LIB_DIR}/colors.sh
source ${LIB_DIR}/bitcoind.sh
source ${LIB_DIR}/spending.sh

function cmd_help() {
  echocyan "USAGE: $0 COMMAND";echo;echo
  echocyan "COMMAND";echo
  echocyan "[b|bootstrap] <name>        ... Initialize a new private blockchain (regtest) and mine first 50 BTC.";echo
  echocyan "[s|simulate] <name> <addr>  ... Transfer a random amount of money in a random amount of transactions to the address <addr>.";echo
  echocyan "[m|mine] <name>             ... Mine one block and include all transactions that are currently in the memory pool, if possible.";echo
  echocyan "[bal|balance] <name>        ... Get the peers balance";echo
  echocyan "[sta|start] <name>          ... Starts a peers instance";echo
  echocyan "[sto|stop] <name>           ... Stops peers instance";echo
  echocyan "[g|getinfo] <name>          ... Gets peers info";echo
  echocyan "[-h|--help]                 ... Shows this help menu";echo
}

case "$1" in
    sta|start)
      if [ -z "$2" ]; then
        cmd_help;
      else
        startDaemon $2
      fi
    ;;
    -h|--help)
      cmd_help;
    ;;
    g|getinfo)
      if [ -z "$2" ]; then
        cmd_help; exit
      else 
        getInfo $2
      fi
    ;;
    sto|stop)
      if [ -z "$2" ]; then
        cmd_help; exit
      else
        stopDaemon $2
      fi
    ;;
    b|bootstrap)
      if [ -z "$2" ]; then
        cmd_help; exit
      else
        terminateBitcoind
        purgingBlockchain $2
        startBitcoind $2
        miningFirstBTC $2
      fi
    ;;
    m|mine)
      if [ -z "$2" ]; then
         cmd_help; exit
      else
        generateBlock $2
      fi
    ;;
    s|simulate)
      if [ -z "$2" ]; then
        cmd_help; exit
      else
        donateRandomAmount $2 $3
        generateBlock $2
        showWalletBalance $2
      fi
    ;;
    bal|balance)
      if [ -z "$2" ]; then
        cmd_help; exit
      else
        showWalletBalance $2
      fi
    ;;
    *)
      cmd_help; exit
    ;;
esac
