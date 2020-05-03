# Crypto Games

Smart contracts for gambling on Ethereum

## Setup

Run Docker:
```
docker-compose up -d
```

## Documentation

_Code is heavily documented to be viewed on Etherscan_

For documentation please refer to functions in `/contracts`:
- `Token.transferAndCall()`
- `Game.play()`
- `<individual_game_contract>.handleSuccess()`

Where `individual_game_contract` can be `Dice` contract for example

## Integration

_Following functions are externally callable_

Dashboard:
- `Dashboard.lastGameId() -> int`
- `Dashboard.gameIds(gameId: int) -> address`
- `Dashboard.games(game: address) -> (int, address, bool)`

Token:
- `Token.transferAndCall(tokens: int, game: address, context: bytes[])`

Example of `transferAndCall` for scenario:
- stake: 100 tokens
- game address: 0x123
- context -> risk: 1111
```
Token.transferAndCall(
    100, 
    0x123, 
    [web3.bytes(1111)]
)
```

How integration can be approached?
_Note: Following examples are for Web3 JavaScript client_
- integrate Web3 with client
```js
const Web3 = require('web3')
```
- configure for Rinkeby testnet network
```js
const web3 = new Web3(
    new Web3.providers.HttpProvider(infuraUrl)
)
```
- load private keys from securely stored credentials
```js
const account = web3.eth.accounts.privateKeyToAccount(privateKey)
```
- integrate ABI interfaces from extracted ABIs in `abi` directory
```js
const abi = JSON.parse(
    fs.readFileSync('abi/Contract.json')
)
```
- instantiate contract
```js
const contract = web3.eth.Contract(abi).at(address)
```
- start integration from Dashboard's methods
- -> they are `call` functions, means they are read-only
- -> they returns simple and complex values
```js
await DashboardContract.lastGameId().call({
    from: account
})
```
- implement `transferAndCall` for Token
- -> this method is `transaction` function, means write-only
- -> it requires to be owner of staked tokens
- -> it accepts address of 
- -> additionally Web3 coded bytes are passed in context
```js
await TokenContract.transferAndCall(
    tokens,
    gameAddress,
    context,
    {
        from: account
    }
)
```
- add creation of new Game contract
```js
new web3.eth.Contract(abi, {
    from: account
})
```
