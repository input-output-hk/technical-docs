The CLI is a proxy to the wallet server, which is required for most commands. Commands are turned into corresponding API calls, and submitted to an up-and-running server. Some commands do not require an active server and can be run "offline". (e.g. 'recovery-phrase generate')

<!--
ATTENTION:

The left and right chevrons (`<` and `>`) aren't displayed in markdown, nor anything in between. So below, I am using
special unicode characters that look alike: `ᐸ` and `ᐳ`
-->

<pre>
Usage: cardano-wallet COMMAND
  Cardano Wallet Command-Line Interface (CLI)

Available OPTIONS:
  -h | --help

Available COMMANDS:
  <a href="#serve">serve</a>                    Serve an HTTP API that listens for commands/actions.
  recovery-phrase
    <a href="#recovery-phrase-generate">generate</a>               Generate an English recovery phrase 
  wallet
    <a href="#wallet-list">list</a>                   List all known wallets
    create
      <a href="#wallet-create-from-recovery-phrase">from-recovery-phrase</a> Create a new wallet using a recovery-phrase
    <a href="#wallet-get">get</a>                    Fetch a particular wallet
    <a href="#wallet-utxo">utxo</a>                   Get a wallet's UTxO distribution
    update
      <a href="#wallet-update-passphrase">passphrase</a>            Update a wallet's master passphrase
      <a href="#wallet-update-name">name</a>                 Update a wallet's name
    <a href="#wallet-delete">delete</a>                 Forget a wallet and its metadata
  transaction
    <a href="#transaction-create">create</a>                 Create a transaction from a known wallet
    <a href="#transaction-fees">fees</a>                   Estimate fees for a transaction
    <a href="#transaction-list">list</a>                   List the transactions associated with a wallet
    <a href="#transaction-submit">submit</a>                 Submit an externally-signed transaction
    <a href="#transaction-forget">forget</a>                 Forget a pending transaction with specified id
  address
    <a href="#address-list">list</a>                   List all known addresses of a wallet
    <a href="#address-create">create</a>                 Create a new random address.
    <a href="#address-import">import</a>                 Import a random address generated elsewhere.
  network
    <a href="#network-information">information</a>            View network information
    <a href="#network-parameters">parameters</a>             View network parameters
    <a href="#network-clock">clock</a>                  View NTP offset
  key
    <a href="#key-from-recovery-phrase">from-recovery-phrase</a>   Convert a recovery phrase to an extended private key
    <a href="#key-child">child</a>                  Derive child keys from a parent public or private key
    <a href="#key-public">public</a>                 Get the public counterpart of a private key
    <a href="#key-inspect">inspect</a>                Show information about a key
  <a href="#version">version</a>                  Show the program's current version
</pre>

> :information_source: The CLI commands for `wallet`, `transaction` and `address` only output valid JSON on `stdout`. So you may redirect the output to a file with `>` or pipe it into utility softwares like `jq`!

> :gift_heart: For bash/zsh auto-completion, put the following script in your `/etc/bash_completion.d`:
>
> <details>
> <summary>cardano-wallet.sh</summary>
>
> ```bash
> _cardano-wallet()
> {
>    local CMDLINE
>    local IFS=$'\n'
>    CMDLINE=(--bash-completion-index $COMP_CWORD)
>
>    for arg in ${COMP_WORDS[@]}; do
>        CMDLINE=(${CMDLINE[@]} --bash-completion-word $arg)
>    done
>
>    COMPREPLY=( $(cardano-wallet "${CMDLINE[@]}") )
> }
>
> complete -o filenames -F _cardano-wallet cardano-wallet
> ```
> </details>
# Commands

## serve

Serve API that listens for commands/actions. Before launching user should start [`cardano-node`](https://github.com/input-output-hk/cardano-node).

### Invocation

> ```
> cardano-wallet serve
>
>   --help-tracing           Show help for tracing options
>   --listen-address HOST    Specification of which host to the bind API server
>                            to. Can be an IPv[46] address, hostname, or
>                            '*'. (default: 127.0.0.1)
>   --random-port            serve wallet API on any available port (conflicts
>                            with --port)
>   --port INT               port used for serving the wallet API. (default: 8090)
>   --tls-ca-cert FILE       A x.509 Certificate Authority (CA) certificate.
>   --tls-sv-cert FILE       A x.509 Server (SV) certificate.
>   --tls-sv-key FILE        The RSA Server key which signed the x.509 server
>                            certificate.
>   --node-socket FILE       Path to the node's domain socket.
>   --testnet FILE           Path to the genesis .json file.
>   --database DIR           use this directory for storing wallets. Run in-memory
>                            otherwise.
>   --sync-tolerance DURATION
>                            time duration within which we consider being synced
>                            with the network. Expressed in seconds with a
>                            trailing 's'. (default: 300s)
>   --shutdown-handler       Enable the clean shutdown handler (exits when stdin
>                            is closed)
>   --log-level SEVERITY     Global minimum severity for a message to be logged.
>                            Individual tracers severities still need to be
>                            configured independently. Defaults to "DEBUG".
>   --trace-NAME SEVERITY    Individual component severity for 'NAME'. See
>                                --help-tracing for details and available tracers.
>
> ```

##### example

Start cardano-node:

- on Byron Mainnet:

```
git clone https://github.com/input-output-hk/cardano-node.git
cd cardano-node
nix-build -A scripts.mainnet.node -o mainnet-node-local && ./mainnet-node-local
```

- on Shelley F&F Testnet:

```
git clone https://github.com/input-output-hk/cardano-node.git
cd cardano-node
nix-build -A scripts.ff.node -o ff-node-local && ./ff-node-local
```

Serve cardano-wallet:

```
cardano-wallet serve --node-socket ~/cardano-node/state-node-mainnet/node.socket --mainnet --database /tmp/mainnet
```

<p align=right><a href="#">top :arrow_heading_up:</a></p>

## Logging options for serve

`serve` accepts extra command-line arguments for
logging (also called "tracing"). Use `--help-tracing` to show the
options, the tracer names, and the possible log levels.

> `cardano-wallet serve --help-tracing`

```
Additional tracing options:

  --log-level SEVERITY     Global minimum severity for a message to be logged.
                           Defaults to "DEBUG" unless otherwise configured.
  --trace-NAME=off         Disable logging on the given tracer.
  --trace-NAME=SEVERITY    Set the minimum logging severity for the given
                           tracer. Defaults to "INFO".

The possible log levels (lowest to highest) are:
  debug info notice warning error critical alert emergency

The possible tracers are:
  application    About start-up logic and the server's surroundings.
  api-server     About the HTTP API requests and responses.
  wallet-engine  About background wallet workers events and core wallet engine.
  wallet-db      About database operations of each wallet.
  pools-engine   About the background worker monitoring stake pools and stake pools engine.
  pools-db       About database operations on stake pools.
  ntp-client     About ntp-client.
  network        About network communication with the node.
```

##### example

Use these options to enable debug-level tracing for certain components
of the wallet. For example, to log all database queries for the wallet
databases, use:

```
$ cardano-wallet serve --trace-wallet-db=debug ...
```

## recovery-phrase generate

> `cardano-wallet recovery-phrase generate [--size=INT]`

Generates an English recovery phrase.

```
$ cardano-wallet recovery-phrase generate
```

These words will be used to create a wallet later. You may also ask for a specific number of words using the `--size` option:

```
$ cardano-wallet recovery-phrase generate --size 21
```

<p align=right><a href="#">top :arrow_heading_up:</a></p>

## wallet list

> `cardano-wallet wallet list [--port=INT]`

Lists all your wallets:

```
$ cardano-wallet wallet list
```

<p align=right><a href="#">top :arrow_heading_up:</a></p>

## wallet create from recovery-phrase

> `cardano-wallet wallet create from-recovery-phrase [--port=INT] <name> [--address-pool-gap=INT]`

Create a new wallet using a sequential address scheme. This is an interactive command that will prompt you for recovery-phrase words and password.

```
$ cardano-wallet wallet create "My Wallet"
Please enter a 15–24 word recovery-phrase sentence: <enter generated recovery-phrase here>
(Enter a blank line if you do not wish to use a second factor.)
Please enter a 9–12 word recovery-phrase second factor: <skip or enter new recovery-phrase here>
Please enter a passphrase: ****************
Enter the passphrase a second time: ****************
```

after this your new wallet will be created

<p align=right><a href="#">top :arrow_heading_up:</a></p>

## wallet get

> `cardano-wallet wallet get [--port=INT] WALLET_ID`

Fetches the wallet with specified wallet id:

```
$ cardano-wallet wallet get 2512a00e9653fe49a44a5886202e24d77eeb998f
```

<p align=right><a href="#">top :arrow_heading_up:</a></p>

## wallet utxo

> `cardano-wallet wallet utxo [--port=INT] WALLET_ID`

Visualize a wallet's UTxO distribution in the form of an histogram with a logarithmic scale.
The distribution's data is returned by the API in a JSON format, e.g.:

```json
{
  "distribution": {
      "10": 1,
      "100": 0,
      "1000": 8,
      "10000": 14,
      "100000": 32,
      "1000000": 3,
      "10000000": 0,
      "100000000": 12,
      "1000000000": 0,
      "10000000000": 0,
      "100000000000": 0,
      "1000000000000": 0,
      "10000000000000": 0,
      "100000000000000": 0,
      "1000000000000000": 0,
      "10000000000000000": 0,
      "45000000000000000": 0
  }
}
```

which could be plotted as:

```
    │
100 ─
    │
    │                                 ┌───┐
 10 ─                         ┌───┐   │   │                   ┌───┐
    │                 ┌───┐   │   │   │   │                   │   │
    │                 │   │   │   │   │   │   ┌───┐           │   │
  1 ─ ┌───┐           │   │   │   │   │   │   │   │           │   │
    │ │   │           │   │   │   │   │   │   │   │           │   │
    │ │   │ │       │ │   │ │ │   │ ╷ │   │ ╷ │   │ ╷       ╷ │   │      ╷
    └─┘   └─│───────│─┘   └─│─┘   └─│─┘   └─│─┘   └─│───────│─┘   └──────│────────────
          10μ₳    100μ₳   1000μ₳   0.1₳    1₳      10₳     100₳        1000₳
```

<p align=right><a href="#">top :arrow_heading_up:</a></p>

## wallet update name

> `cardano-wallet wallet update name [--port=INT] WALLET_ID STRING`

Updates name of a wallet given wallet id:

```
$ cardano-wallet wallet update name 2512a00e9653fe49a44a5886202e24d77eeb998f NewName
```

<p align=right><a href="#">top :arrow_heading_up:</a></p>

## wallet update passphrase

> `cardano-wallet wallet update passphrase [--port=INT] WALLET_ID`

Interactive prompt to update the wallet master's passphrase (old passphrase required).

```
$ cardano-wallet wallet update passphrase 2512a00e9653fe49a44a5886202e24d77eeb998f
Please enter your current passphrase: **********
Please enter a new passphrase: **********
Enter the passphrase a second time: **********
```

<p align=right><a href="#">top :arrow_heading_up:</a></p>

## wallet delete

> `cardano-wallet wallet delete [--port=INT] WALLET_ID`

Deletes wallet with specified wallet id:

```
$ cardano-wallet wallet delete 2512a00e9653fe49a44a5886202e24d77eeb998f
```

<p align=right><a href="#">top :arrow_heading_up:</a></p>

## transaction create

> `cardano-wallet transaction create [--port=INT] WALLET_ID --payment=PAYMENT...`

Creates and submits a new transaction:

```
$ cardano-wallet transaction create 2512a00e9653fe49a44a5886202e24d77eeb998f \
    --payment 22@Ae2tdPwUPEZ...nRtbfw6EHRv1D \
    --payment 5@Ae2tdPwUPEZ7...pVwEPhKwseVvf
```

This creates a transaction that sends 22 lovelace to `Ae2tdPwUPEZ...nRtbfw6EHRv1D` and 5 lovelace to `Ae2tdPwUPEZ7...pVwEPhKwseVvf` from wallet with id 2512a00e9653fe49a44a5886202e24d77eeb998f.

<p align=right><a href="#">top :arrow_heading_up:</a></p>

## transaction fees

> `cardano-wallet transaction fees [--port=INT] WALLET_ID --payment=PAYMENT...`

Estimates fee for a given transaction:

```
$ cardano-wallet transaction fees 2512a00e9653fe49a44a5886202e24d77eeb998f \
    --payment 22@Ae2tdPwUPEZ...nRtbfw6EHRv1D \
    --payment 5@Ae2tdPwUPEZ7...pVwEPhKwseVvf
```

This estimates fees for a transaction that sends 22 lovelace to `Ae2tdPwUPEZ...nRtbfw6EHRv1D` and 5 lovelace to `Ae2tdPwUPEZ7...pVwEPhKwseVvf` from wallet with id 2512a00e9653fe49a44a5886202e24d77eeb998f.

<p align=right><a href="#">top :arrow_heading_up:</a></p>

## transaction list

> `cardano-wallet transaction list [--port INT] WALLET_ID [--start TIME] [--end TIME] [--order ORDER]`

List all incoming and outgoing transactions for the wallet:

```
$ cardano-wallet transaction list 2512a00e9653fe49a44a5886202e24d77eeb998f \
    --start 2018-09-25T10:15:00Z \
    --end 2019-11-21T10:15:00Z \
    --order ascending
```

This lists all transactions between `2018-09-25T10:15:00Z` and `2019-11-21T10:15:00Z` in `ascending` order.

<p align=right><a href="#">top :arrow_heading_up:</a></p>

## transaction submit

> `cardano-wallet transaction submit [--port INT] BINARY_BLOB`

Submit transaction prepared and signed outside of the wallet:

```
$ cardano-wallet transaction submit 00bf02010200000...d21942304
```

Sends transaction identified by a hex-encoded BINARY_BLOB of externally-signed transaction.

<p align=right><a href="#">top :arrow_heading_up:</a></p>

## transaction forget

> `cardano-wallet transaction forget [--port INT] WALLET_ID TRANSACTION_ID`

Forget pending transaction for a given wallet:

```
$ cardano-wallet transaction forget 2512a00e9653fe49a44a5886202e24d77eeb998f 3e6ec12da4414aa0781ff8afa9717ae53ee8cb4aa55d622f65bc62619a4f7b12
```

<p align=right><a href="#">top :arrow_heading_up:</a></p>

## address list

> `cardano-wallet address list [--port=INT] WALLET_ID [--state=STRING]`

List all known (used or not) addresses and their corresponding status.

```
$ cardano-wallet list addresses 2512a00e9653fe49a44a5886202e24d77eeb998f
```

<p align=right><a href="#">top :arrow_heading_up:</a></p>

## address create

> `cardano-wallet address create [--port INT] [--address-index INDEX] WALLET_ID`

Create new address for random wallet. 

```
$ cardano-wallet address create 03f4c150aa4626e28d02be95f31d3c79df344877
Please enter your passphrase: *****************
Ok.
{
    "state": "unused",
    "id": "2w1sdSJu3GVgr1ic6aP3CEwZo9GAhLzigdBvCGY4JzEDRbWV4HUNpZdHf2n5fV41dGjPpisDX77BztujAJ1Xs38zS8aXvN7Qxoe"
}
```
<p align=right><a href="#">top :arrow_heading_up:</a></p>

## address import

> `cardano-wallet address import [--port INT] WALLET_ID ADDRESS`

Import address belonging to random wallet.

<p align=right><a href="#">top :arrow_heading_up:</a></p>

## network information

> `cardano-wallet network information [--port=INT]`

View network information and syncing progress between the node and the blockchain.

```
$ cardano-wallet network information
```

<p align=right><a href="#">top :arrow_heading_up:</a></p>

## network parameters

> `cardano-wallet network parameters [--port=INT] EPOCH_NUMBER`

View network parameters. EPOCH_NUMBER can be `latest` or valid epoch number (not later than the current one), ie., `0`, `1`, .. .

```
$ cardano-wallet network parameters latest
```

<p align=right><a href="#">top :arrow_heading_up:</a></p>

## network clock

> `cardano-wallet network clock`

View [NTP](https://en.wikipedia.org/wiki/Network_Time_Protocol) offset for cardano-wallet server in microseconds.

```
$ cardano-wallet network clock
Ok.
{
    "status": "available",
    "offset": {
        "quantity": -30882,
        "unit": "microsecond"
    }
}
```
> :warning: At this stage the command is not supported on Windows platform. Invoked on Windows will return `status: unavailable` in the response message.

<p align=right><a href="#">top :arrow_heading_up:</a></p>

## key from-recovery-phrase

Extract the root extended private key from a recovery phrase. New recovery phrases can be generated using <a href="#recovery-phrase-generate">`recovery-phrase generate`</a>.

> ```
> Usage: cardano-wallet key from-recovery-phrase ([--base16] | [--base58] | [--bech32]) STYLE
>   Convert a recovery phrase to an extended private key
> 
> Available options:
>   -h,--help                Show this help text
>   STYLE                    Byron | Icarus | Jormungandr | Shelley
> 
> The recovery phrase is read from stdin.


Example:

```console
$ cardano-wallet recovery-phrase generate | cardano-wallet key from-recovery-phrase Icarus
xprv12qaxje8hr7fc0t99q94jfnnfexvma22m0urhxgenafqmvw4qda0c8v9rtmk3fpxy9f2g004xj76v4jpd69a40un7sszdnw58qv527zlegvapwaee47uu724q4us4eurh52m027kk0602judjjw58gffvcqzkv2hs
```

<p align=right><a href="#">top :arrow_heading_up:</a></p>

## key child

Derive child key from root private key. The parent key is read from standard input.

> ```
> Usage: cardano-wallet key child ([--base16] | [--base58] | [--bech32]) [--legacy] DERIVATION-PATH
>   Derive child keys from a parent public/private key
> 
> Available options:
>   -h,--help                Show this help text
>   DERIVATION-PATH          Slash-separated derivation path. 
>                            Hardened indexes are marked with a 'H' (e.g. 1852H/1815H/0H/0).
> 
> The parent key is read from stdin.
> ```

```console
$ cardano-wallet recovery-phrase generate | cardano-wallet key from-recovery-phrase Icarus > root.xprv
$ cat root.xprv | cardano-wallet key child 44H/1815H/0H/0
xprv13parrg5g83utetrwsp563w7hps2chu8mwcwqcrzehql67w9k73fq8utx6m8kgjlhle8claexrtcu068jgwl9zj5jyce6wn2k340ahpmglnq6x8zkt7plaqjgads0nvmj5ahav35m0ss8q95djl0dcee59vvwkaya
```

<p align=right><a href="#">top :arrow_heading_up:</a></p>

## key public

Extract the public key of an extended private key. Keys can be obtained using <a href="#key-from-recovery-phrase">`key from-recovery-phrase`</a> and <a href="#key-child">`key child`</a>. 

> ```
> Usage: cardano-wallet-jormungandr key public ([--base16] | [--base58] | [--bech32])
>   Get the public counterpart of a private key
> 
> Available options:
>   -h,--help                Show this help text
> 
> The private key is read from stdin.
> ```

```console
$ cardano-wallet recovery-phrase generate | cardano-wallet key from-recovery-phrase Icarus > root.xprv
$ cat root.xprv | cardano-wallet key public
xpub1le8gm0m5cesjzzjqlza4476yncp0yk2jve7cce8ejk9cxjjdama24hudzqkrxy4daxwmlfq6ynczj338r7f5kzs43xs2fkmktekd4fgnc8q98
```

<p align=right><a href="#">top :arrow_heading_up:</a></p>

## key inspect

> ```
> Usage: cardano-wallet-jormungandr key inspect 
>   Show information about a key
> 
> Available options:
>   -h,--help                Show this help text
> 
> The parent key is read from stdin.
> ```

<p align=right><a href="#">top :arrow_heading_up:</a></p>


## version

> `cardano-wallet version`

Show the software version.

<p align=right><a href="#">top :arrow_heading_up:</a></p>
