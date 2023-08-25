# Polkascan Explorer
<img width="332" valign="top" alt="Screenshot 2022-10-10 at 10 03 34" src="https://user-images.githubusercontent.com/5286904/194822070-48c172d4-c65d-4ea0-8287-15b772f32eb4.png"> <img width="312" valign="top" alt="Screenshot 2022-10-10 at 10 30 11" src="https://user-images.githubusercontent.com/5286904/194826118-9d655e0c-02d3-4a8c-b4f1-73bfc00e076b.png">

Polkascan Explorer provides a generalized block explorer for 
[Substrate](https://github.com/paritytech/substrate)-based blockchains.

It combines data retrieved directly from the Substrate node RPC with data retrieved from a third-party indexer API.

At the moment the following third-party data are supported: 

* Polkascan API
* Subsquid 

## Installation using Subsquid endpoints

See the installation instructions of the [Polkascan Explorer UI repos](https://github.com/polkascan/explorer-ui) if the explorer is solely going to run with [Subsquid](https://www.subsquid.io/) endpoints.

## Installation using Polkascan API endpoints
Run `init.sh` to initialize repository; this will basically run:
  * `git submodule update --init --recursive`  
  * `cp explorer-ui-config.json explorer-ui/src/assets/config.json`
  * `cp explorer-ui-privacy-policy.html explorer-ui/src/assets/privacy-policy.html`

The [explorer-ui-config.json](https://github.com/polkascan/explorer/blob/main/explorer-ui-config.json) file contains 
the URLs of the exposed Substrate and Explorer API endpoints

## Running the application

### Docker

* `docker-compose up --build`

### Local

#### Harvester
* `cd harvester`
* `pip install -r requirements.txt`
* `./harvester-cli.sh run`

#### Explorer API

* `cd explorer-api`
* `pip install -r requirements_api.txt`
* `./start-api.sh`

#### Explorer UI

For a dev server, open a terminal and run:
```shell
cd polkadapt
npm i
npm run build
``` 
When making changes in `polkadapt` source files you have to build again.

Now open a second terminal and run:
```shell
npm i
npm run start
```
Navigate to `http://localhost:4200/`. The app will automatically reload if you change any of the source files.

## Services
* Polkascan UI: http://127.0.0.1:8080/
* Polkascan API playground: http://127.0.0.1:8000/graphql/
* Polkascan API websocket: ws://127.0.0.1:8000/graphql-ws
* MySQL database exposed at mysql://root:root@localhost:33061

For more information or modification see the [Docker compose file](https://github.com/polkascan/explorer/blob/main/docker-compose.yml)

## Components

The explorer application consist of several components:

### Harvester component

The [harvester](https://github.com/polkascan/harvester) retrieves data from the connected 
Substrate node and stores it into a MySQL (by default) database.

#### Storage cron

With the processing of each block, it can also be desirable to retrieve and decode certain storage records. By default, 
for every block the `System.Events` are stored as this is a fundamental element to determine which calls are executed.

When other storage records are needed, for example a balance snapshot of all accounts every 10000 blocks, additional 
cron items can be added:

```bash
cd harvester
./harvester-cli.sh storage-cron add 

> Block interval (e.g. 10 = every 10th block): 10000
> Pallet: System
> Storage function: Account
> Added cron System.Account every 10000 blocks
```

Check the current storage cron items:
```
  Id    Block interval  Pallet    Storage name
----  ----------------  --------  --------------
   1                 1  System    Events
   2             10000  System    Account
```

Then run the harvester:
```bash
./harvester-cli.sh run 
```

#### Storage tasks

When storage cron items retrieve records as part of the block harvest process, storage tasks can be added to retrieve 
records for any given blocks that are already processed. 

Also, this feature can be used standalone, so it basically acts as a storage harvester.

Example: Store total issuance for blocks 1-1000:
```bash
cd harvester
./harvester-cli.sh storage-tasks add
> Pallet: Balances
> Storage function: TotalIssuance
> Blocks (e.g. '100,104' or '100-200'): 1-1000
> Added task Balances.TotalIssuance for blocks 1-1000 
```

Then run only the 'cron' job of the harvester:
```bash
./harvester-cli.sh run --job cron 
```

List progress of tasks:

```bash
./harvester-cli.sh storage-tasks list
>   Id  Pallet    Storage name    Blocks                                 Complete
> ----  --------  --------------  -------------------------------------  ----------
>    1  System    Account         {'block_ids': [1, 2]}                  True
>    2  Balances  TotalIssuance   {'block_end': 1000, 'block_start': 1}  True
```

### Explorer API component

The [explorer API](https://github.com/polkascan/explorer-api) transforms the data via an ETL process into an 
explorer-specific format. It exposes a GraphQL endpoint and enables subscription-based communication to the UI.

### Explorer UI component

[Explorer UI](https://github.com/polkascan/explorer-ui) is a client-sided [Angular](https://angular.io/) based application that utilizes 
[PolkADAPT](https://github.com/polkascan/polkadapt) and its Adapters to obtain data from multiple data sources, like 
the Explorer API and the Substrate node. Its design is based on flat [Material](https://material.angular.io/) component 
design, styled in Polkascan branding.

## Modifications

### Substrate Node
By default, a build of [Substrate Node Template](https://github.com/substrate-developer-hub/substrate-node-template) is 
used. If a local Substrate node is already running on the host machine, you can change
environment variable in the [docker-compose.yml](https://github.com/polkascan/explorer/blob/main/docker-compose.yml#L15):
`SUBSTRATE_RPC_URL=ws://host.docker.internal:9944`

Or to any public or private websocket endpoint

To use PolkadotJS Apps with the local Substrate node, go to https://polkadot.js.org/apps/?rpc=ws%3A%2F%2F127.0.0.1%3A9944#/explorer

### Explorer UI 

#### Datasources

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

## Known Issues and Limitations

* Substrate runtimes that implements metadata prior to `MetadataV14` decode in a different format as expected by the explorer, so not all functionality is available. This can have effect on early blocks as well, a workaround is to set `BLOCK_START` env setting for the harvester, to a block number with `MetadataV14`.
* Errors during building `explorer-ui` Docker container on M1 architecture. This could happen when the chromium binary is not available for arm64, there is [a workaround available](https://github.com/polkascan/explorer-ui/issues/26)
* Currently, the `explorer-api` application supports Python version >3.6 and <3.10 

## License
https://github.com/polkascan/explorer/blob/main/LICENSE
