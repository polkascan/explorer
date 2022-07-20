# Polkascan Explorer

Polkascan Explorer provides a generalized block explorer for 
[Substrate](https://github.com/paritytech/substrate)-based blockchains.

## Installation
Run `init.sh` to initialize repository; this will basically run:
  * `git submodule update --init --recursive`  
  * `cp explorer-ui-config.json explorer-ui/src/assets/config.json`

The [explorer-ui-config.json](https://github.com/polkascan/explorer/blob/main/explorer-ui-config.json) file contains 
the URLs of theexposed Substrate and Explorer API endpoints

## Running the application
* `docker-compose up --build`

## Links
* Polkascan UI: http://127.0.0.1:8080/
* Polkascan API playground: http://127.0.0.1:8000/graphql/
* Polkascan API websocket: ws://127.0.0.1:8000/graphql-ws

## Components

The explorer application consist of several components:

### Harvester component

The [harvester](https://github.com/polkascan/harvester) retrieves data from the connected 
Substrate node and stores it into a MySQL (by default) database.

### Explorer API component

The [explorer API](https://github.com/polkascan/explorer-api) transforms the data via an ETL process into an 
explorer-specific format. It exposes a GraphQL endpoint and enables subscription-based communication to the UI.

### Explorer UI component

[Explorer UI](https://github.com/polkascan/explorer-ui) is a client-sided [Angular](https://angular.io/) based application that utilizes 
[PolkADAPT](https://github.com/polkascan/polkadapt) and its Adapters to obtain data from multiple data sources, like 
the Explorer API and the Substrate node. Its design is based on flat [Material](https://material.angular.io/) component 
design, styled in Polkascan branding.

# Modifications

## Substrate Node
By default, a build of [Substrate Node Template](https://github.com/substrate-developer-hub/substrate-node-template) is 
used. If a local Substrate node is already running on the host machine, you can change
environment variable in the [docker-compose.yml](https://github.com/polkascan/explorer/blob/main/docker-compose.yml#L15):
`SUBSTRATE_RPC_URL=ws://host.docker.internal:9944`

Or to any public or private websocket endpoint

To use PolkadotJS Apps with the local Substrate node, go to https://polkadot.js.org/apps/?rpc=ws%3A%2F%2F127.0.0.1%3A9944#/explorer

## Explorer UI 

### Datasources

The UI is utilizing [PolkAdapt](https://github.com/polkascan/polkadapt) to combine on-chain data retrieved directly from the Substrate node, with the GraphQL endpoint with indexed data served by the [Explorer API](https://github.com/polkascan/explorer-api). In this way data like events and extrinsics can be retrieved fast, with the verification of on-chain data.


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
