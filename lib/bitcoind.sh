######################################
# Stop all peers
#####################################
function stopAll() {
  for dir in ${PEERS_DIR}*/
    do
      dir=${dir%*/}
      echoyellow "[DAEMON] Stopping peer '${dir##*/}'"; echo
      stopDaemon ${dir##*/}
    done
    echogreen "[DAEMON] Finished Stopping all peers"; echo

}

#####################################
# Starts all peers
#####################################
function startAll() {
  for dir in ${PEERS_DIR}*/
    do
      dir=${dir%*/}
      echoyellow "[DAEMON] Starting peer '${dir##*/}'"; echo
      startDaemon ${dir##*/}
    done
    echogreen "[DAEMON] Finished Starting all peers"; echo

}

######################################
# Stopping previous running instance
######################################
function terminateBitcoind() {
  if [ -f ${PID_FILE} ]; then
    echoyellow "[WARN] Found previously started instance. Killing '$(<${PID_FILE})'!"; echo
    kill -9 $(<${PID_FILE}) 2> /dev/null
    rm -f ${PID_FILE} ${LOG_FILE}
    # Waiting until bitcoind has stopped
    sleep ${SLEEP_TIME}
  fi
}

######################################
# Cleaning up old blockchain
######################################
function purgingBlockchain() {
  echoyellow "[WARN] Deleting directory '${PEERS_DIR}$1/regtest' in "
  for i in `seq 5 -1 1`; do
    echored  $i
    sleep 1
    echo -n " "
  done
  rm -rf ${PEERS_DIR}/$1/regtest 
  echo
}

######################################
# Starting a fresh bitcoin daemon instance
######################################
function startBitcoind() {
  ${BR_START} ${DATA_DIR}$1 ${DAEMON} &  
  ${BITCOIN_CLI} ${DATA_DIR}$1 ${BR_OPTS} &> ${LOG_FILE} & echo $! > ${PID_FILE}

  echoyellow "[DAEMON] '$1'"; echo
  echogreen "[DAEMON] Starting '${BITCOIN_CLI}' '${DATA_DIR}$1' '${BR_OPTS}' with PID '$(<${PID_FILE})'"; echo
  echogreen "[DAEMON] Logfile under '${LOG_FILE}'"; echo

  # Waiting until bitcoind has started
  sleep ${SLEEP_TIME}
}

######################################
# Mining first 101 Bitcoin in order to
# be able to access the first one.
######################################
function miningFirstBTC() {
  echocyan "[MINING] Mining Bitcoin. Please be patient for ~1 minute"; echo
  echoyellow "'${BITCOIN_CLI}' '${DATA_DIR}$1' generate 101"; echo
  
  ${BITCOIN_CLI} ${DATA_DIR}$1 generate 101

  BALANCE=$(${BITCOIN_CLI} ${DATA_DIR}$1 getbalance)
  echocyan "[WALLET] $1 wallet balance: \e[1m\e[7m${BALANCE} BTC\e[0m"; echo
}

######################################
# Start daemon for specific peer
######################################
function startDaemon() {
  echocyan "[DAEMON] Starting '$1' daemon"; echo
  echocyan "[DAEMON] '${BR_START}' '${DATA_DIR}$1' '${DAEMON}'"; echo
  
  ${BR_START} ${DATA_DIR}$1 ${DAEMON}

  echogreen "[DAEMON] '$1' daemon started"; echo
}
  

#######################################
# Stop daemon for specific peer
#######################################
function stopDaemon() {
  echoyellow "[WARN] Stopping '$1' daemon in ctl+c to stop "
  for i in `seq 5 -1 1`; do
    echored $i
    sleep 1
    echo -n " "
  done; echo
  echocyan "[DAEMON] '${BITCOIN_CLI}' '${DATA_DIR}$1' stop"; echo

  ${BITCOIN_CLI} ${DATA_DIR}$1 stop 

  echocyan "[DAEMON] '$1' daemon is stopped"; echo
}

#######################################
# GetInfo for specific peer
#######################################
function getInfo() {
  echocyan "[DAEMON] Getting '$1' info"; echo
  echoyellow "'${BITCOIN_CLI}' '${DATA_DIR}$1' getinfo"; echo

  ${BITCOIN_CLI} ${DATA_DIR}$1 getinfo

  echo 
} 

#######################################
# Get new wallet address
#######################################
function getNewAddress() {
  echocyan "[DAEMON] Getting new address for '$1'"; echo
  echoyellow "'${BITCOIN_CLI}' '${DATA_DIR}$1' getnewaddress"; echo
 
  ${BITCOIN_CLI} ${DATA_DIR}$1 getnewaddress

  echo
}

#########################################
# Bootstrap all peers in peers directory
#########################################
function bootstrapAll() {
  echo "${PEERS_DIR}"; 
  for dir in ${PEERS_DIR}*/
    do
      dir=${dir%*/}
      echocyan "[DAEMON] Starting Bootstrap for peer '${dir}'"; echo
      terminateBitcoind 
      purgingBlockchain ${dir##*/}
      startBitcoind ${dir##*/}
      miningFirstBTC ${dir##*/}
    done
    echocyan "[DAEMON] Finished Bootstrapping all peers"; echo
}

##########################################
# Get all peer info at once
##########################################
function getAllInfo() {
  for dir in ${PEERS_DIR}*/
    do
      dir=${dir%*/}
      echocyan "[DAEMON] getting '${dir}' info now"; echo
      getInfo ${dir##*/}
    done
    echocyan "[DAEMON] Finished getting all peers info"; echo
}




































   
