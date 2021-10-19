# Punk Token IBCO
The fundraising event of the PUNK token will be held through a so-called IBCO. This stands for Initial Bond Curve Offering. This is an offering where participants send funds (xDai) to a contract with a fixed supply of tokens during a set timespan. After the Offering has been completed, partipants can claim Punk tokens. The amount of tokens are proportional to the funds they have sent to the contract. The fixed supply will be devided, pro rata, amongst the participants. 

An IBCO allows for a fair way to determine the value of a token and has the following properties:
- 🤍 Same settlement price for everyone
- 🤍 No front-running
- 🤍 No pumps & dumps by whales
- 🤍 No price manipulations
- 🤍 Price increases with every purchase
- 🤍 Collective, not competitive, contributions
- 🤍 Pooling contributions in one batch

## Truffle
The token has been created using Truffle and OpenZeppelin 

### Deploying the token on a local environment
Install truffle and ganache-cli globally:
```sh
npm i truffle -g && npm i ganache-cli -g
```

Install dependencies

```sh
npm i 
```

Run truffle commands for example

```sh
ganche-cli

truffle build

truffle deploy
```

### Testing the IBCO contract
Have ganache running

```sh
ganche-cli
```

Install dependencies

```sh
npm i
```

Deploy the Punk token https://github.com/xDaiPunks/PunkTokenContract

```sh
truffle migrate
```

In the console you will see a contract address. This contract address is needed for the deployment of the IBCO contract

Add the contract address, the current unix time and 600 seconds to the 1_initial_migration.js file. 

https://github.com/xDaiPunks/PunkTokenContract/blob/main/migrations/1_initial_migration.js

The current unix time can be found using javascript as well 

```sh
Math.round(new Date().getTime() / 1000)
```

To run the tests, run the following command

```sh
npm run test
```



## Remix
To interact with this contract using Remix IDE (https://remix.ethereum.org/) using your local file system, you can install the remixd package.

If you want to test the claim command, please make sure the project is funded by transferrring funds from a deployed Token contract (https://github.com/xDaiPunks/PunkTokenContract)

```sh
npm install -g @remix-project/remixd
```

After install you can start remixd by issuing the followinng command:

```sh
remixd -s ~/YOUR-CONTRACT-DIRECTORY --remix-ide https://remix.ethereum.org/

```
Then in the Remix IDE choose 'localhost' as workspace and connect. You can also use your local ganache instance with Remix IDE. To do so, select 'Web3 Provider' for the environment. Make sure to have ganache-cli running 
