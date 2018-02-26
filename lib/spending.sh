######################################
# Donate to address
######################################
function donateRandomAmount() {

  AMOUNT=0$(echo "scale=8; ${RANDOM} / 100000.0" | bc)
  echogreen "[ADDRESS] Transferring '${AMOUNT}' to address '${2}'"; echo
  TRX=$(${BITCOIN_CLI} ${DATA_DIR}$1 sendfrom "${WALLET_ACCOUNT}" $2 ${AMOUNT})
  echoyellow "\t|-> Transferred ${AMOUNT} BTC in trx '${TRX}'";echo
}

function generateBlock() {
  echocyan "[INFO] Generating new block!"; echo
  ${BITCOIN_CLI} ${DATA_DIR}$1 generate 1

  blk_hash=$(${BITCOIN_CLI} ${DATA_DIR}$1 getbestblockhash)
  blk=$(${BITCOIN_CLI} ${DATA_DIR}$1 getblock $blk_hash)
  txsize=$(ruby -rjson -e "puts JSON.parse('$blk')['tx'].size") 
  echocyan "\t|-> Block Hash: ${blk_hash}";echo
  echocyan "\t|-> TRX Number: ${txsize}";echo
}

############################################
# mine x amount of blocks
############################################
function mineXblocks() {
  echocyan "[DAEMON] Generating '$2' blocks..."; echo
  ${BITCOIN_CLI} ${DATA_DIR}$1 generate $2
}

function showWalletBalance() {
  BALANCE=$(${BITCOIN_CLI} ${DATA_DIR}$1 getbalance)
  echocyan "[WALLET] Current balance: \e[1m\e[7m${BALANCE} BTC\e[0m"; echo
}

function randomInteger() {
  echo $((RANDOM%10+1))
}