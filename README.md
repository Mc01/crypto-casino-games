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

For documentation please refer to functions:
- `Token.transferAndCall()`
- `Game.play()`
- `<individual_game_contract>.handleSuccess()`

Where `individual_game_contract` can be `Dice` contract for example

## Externally interface

_Following functions are externally callable_

Dashboard:
- Read
-> `Dashboard.lastGameId() -> int`
-> `Dashboard.gameIds(gameId: int) -> address`
-> `Dashboard.games(game: address) -> (int, address, bool)`

Token:
- Write
-> `Token.transferAndCall(tokens: int, game: address, context: bytes[])`
