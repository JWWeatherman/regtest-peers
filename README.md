# Bitcoin Regtest w/ Peers #

This repository contains instructions, with related helper code, that allows you to run your own blockchain locally with 3 connected peers. Get started pretty fast and develop your own Bitcoin application.

### Why this project?

This collection of instructions, with related scripts, should help Bitcoin
application developers. Instead of spending hours with setting up a testing
environment, the developer can focus on her application. The created environment allows the complete testing of the Bitcoin part, without spending real money or delays. The environment is reproducible and different scenarios, e.g. collection of transactions in a predefined order, can be created, but also deleted again.

In comparison with the testnet3 Bitcoin network, this environment is not
dependent on external nodes. All happens locally and could be fully controlled
by the developer.

### Who should use this project?

* **Bitcoin Application Develpers:** The main target audience are developers
that need a deterministic and reproducible environment for Bitcoin application
development and testing.
* **People interested in how the Bitcoin blockchain works:** By running a
complete blockchain locally, it is easy to play around with different scenarios
and multiple nodes. It is not only a lot of fun, to play around with an own
blockchain, but improves the understanding of how a decentralized ledger works.

## Installation of Bitcoin Core ##

Installation of the official bitcoin core implementation from
https://bitcoin.org/en/download

    ~$ BITCOIN_VERSION=0.15.1 # You may want to change this value to the current version.
    ~$ wget https://bitcoin.org/bin/bitcoin-core-${BITCOIN_VERSION}/bitcoin-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz    
    ~$ tar xf bitcoin-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz    
    # Change 64 to 32 for 32bit architecture
    ~$ mv bitcoin-${BITCOIN_VERSION}-linux/bin/* /usr/local/bin

## Peers ##

There is three peers setup in the `peers` directory. Peers are connected allowing you to use one of the wallets for mining pool development. Then connected peers make a complete block chain. After running this app you will be able to add as many peers as you need very easily. It is very important to `bootstrap` all of the peers to ensure the blockchain is complete.

## Quickstart ##

Setup your a peers private blockchain in regtest mode and mine 50 BTC. In this
version we assume that `bitcoind` is installed. Try `bitcoin-cli -help`. 

Do this for all of the peers found in `/peers` to ensure blockchain is complete. 

`<Peername>` refers to the directory name found in `/peers` e.g. `/peers/Bob/` == `Bob`. Name is case sensitive.

**Attention:** The previous blockchain, with related wallet, will be deleted!
You can make a backup of the `/peers/<Peername>/regtest` directory, if you want to
keep a snapshot of the current version.

    ~$ ./btc_node.sh bootstrap <Peername>
    # Alternative short command:
    ~$ ./btc_node.sh b <Peername>

Simulate a random number of transactions to the given address (between 1 and 10), with a random BTC amount each time (between 0 and 1).

    ~$ ./btc_node.sh simulate <Peername> n44FXNKLPbqj3awCXDtNSZrrJonoX9NQsg
    # Alternative short command:
    ~$ ./btc_node.sh s <Peername> n44FXNKLPbqj3awCXDtNSZrrJonoX9NQsg

Each collection of transactions is confirmed¸ at the end of the command, by
creating a new block. For manual mining of one block, use the following
command.

    ~$ ./btc_node.sh mine <Peername>
    # Alternative short command:
    ~$ ./btc_node.sh m <Peername>
 
----

**For all:**

Switch to new console and let the bitcoind running. We generate 101 new blocks
(starting from the genesis block), in order to be able to access the first one
and get 50 BTC.

    ~$ bitcoin-cli -datadir=path/to/peers/<Peername> generate 101
    ... # Wait until all blocks are generated, ~1 minute
    ~$ bitcoin-cli -datadir=path/to/peers/<Peername> getbalance
    50.00000000 # <= You should see that or at least a number bigger then zero.

**Congratulations!** You have now your first BTC that you can spent.

Where to go from here? Please read further how to spent this BTC and how to make
 the whole a little bit more effective, with less typing and more automated.

## Preparing your working environment ##

We don't want to type each time `bitcoin-cli -regtest`. The command `br` is easier
to type and easy to remember: The beginning letters of the command.

    ~$ echo 'alias br <Peername>="bitcoin-cli -datadir=path/to/peers/<Peername>"' >> ~/.bashrc; source ~/.bashrc
    ~$ br <Peername> getbalance

## Support this project ##

Please help us to extend and improve this project.

1. Fork it!
2. Make your changes.
3. Create a pull request.
