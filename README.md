# xDaiPunks WebApp
This is the first commit of the WebApp of xDaiPunks. It is a typical xDaiPunk WebApp. That means not a test to be found. We are still Human test bots

## Architecture
The WebApp connects to the Api to get  it's initial data object consisting of 10k Punks. This data object gets updated through contract events directly using the xdai ws connections. The ws connections might fail at times and allthough they reconnect, there can be data-gaps. A refresh of the webApp will get the data object again from the API that will be in sync

## Running the app
Please use nodejs 14 to run the app. node-sass-chokidar will fail on nodejs 16

To run the dev environment locally:

```sh
npm i && npm run start
```

To build a production version:

```sh
npm run build-production
```

After generating the production version, you can run it locally by running a server like http-server from the build folder

The production build will throw an error as the copy file 



## Connecting remix to localhost

from contract folder
remixd -s ~/Projects/Nodejs/Punks/resources/xIP-000005 --remix-ide https://remix.ethereum.org/ 

