# Crypto Games

Smart contracts for gambling on Ethereum

## Setup

- Install Brownie with:
```
pip install -r requirements.txt
```

- Install OpenZeppelin and Provable with:
```
npm install
```

or just ran Docker:
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
- integrate Web3 with client
- configure for Rinkeby testnet network
- load private keys from securely stored credentials
- integrate ABI interfaces
- instantiate contract
- start integration from Dashboard's methods
- -> they are `call` functions, means they are read-only
- -> they returns simple and complex values
- implement `transferAndCall` for Token
- -> this method is `transaction` function, means write-only
- -> it requires to be owner of staked tokens
- -> it accepts address of 
- -> additionally Web3 coded bytes are passed in context
- add creation of new Game contract
