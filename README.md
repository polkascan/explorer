# Polkascan Explorer

## Installation
Run `init.sh` to initialize repository; this will basically run:
  * `git submodule update --init --recursive`  
  * `cp explorer-ui-config.json explorer-ui/src/assets/config.json`

## Run
* `docker-compose up --build`

## Links
* Polkascan UI: http://127.0.0.1:8080/
* Polkascan API: http://127.0.0.1:8000/graphql/

# Modifications

## Substrate Node
By default, a build of [Substrate Node Template](https://github.com/substrate-developer-hub/substrate-node-template) is 
used. If a local Substrate node is already running on the host machine, you can change
environment variable:
`SUBSTRATE_RPC_URL=ws://host.docker.internal:9944`

Or of course change this to any public or private websocket endpoint

To use PolkadotJS Apps with the local Substrate node, go to https://polkadot.js.org/apps/?rpc=ws%3A%2F%2F127.0.0.1%3A9944#/explorer

## Explorer UI config.json

By default, the UI are using the local endpoints, new networks can be added by extending the dict:

```json
{
  "local": {
    "substrateRpcUrlArray": ["ws://127.0.0.1:9944"],
    "explorerWsUrlArray": ["ws://127.0.0.1:8000/graphql-ws"]
  },
  "polkadot": {
    "substrateRpcUrlArray": ["wss://<PUBLIC_ENDPOINT>"],
    "explorerWsUrlArray": ["wss://<HOSTED_EXPLORER_API_ENDPOINT>/graphql-ws"]
  }
}
```
