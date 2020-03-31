pragma solidity >=0.5.0 <0.7.0;

import "../node_modules/@openzeppelin/contracts/ownership/Ownable.sol";


contract Dashboard is Ownable {
    // game ids and list of games
    mapping (uint256 => address) private _gameIds;
    uint256 private _lastGameId;
    mapping (address => Game) private _games;

    // game model
    struct Game {
        uint256 gameId;
        address gameAddress;
        bool isActive;
    }

    // initializer
    constructor() public
    Ownable() {}

    // getters
    function gameIds(uint256 gameId) external view
    returns (address) {
        return _gameIds[gameId];
    }
    function lastGameId() external view
    returns (uint256) {
        return _lastGameId;
    }
    function games(address gameId) external view
    returns (uint256, address, bool) {
        Game memory game = _games[gameId];
        return (game.gameId, game.gameAddress, game.isActive);
    }

    // setters
    function addGameAddress(address gameAddress) external
    onlyOwner() {
        if (_games[gameAddress].gameId == 0) {
            _lastGameId += 1;
            _gameIds[_lastGameId] = gameAddress;
            _games[gameAddress] = Game(
                _lastGameId,
                gameAddress,
                true
            );
        }
        else if (!_games[gameAddress].isActive) {
            _games[gameAddress].isActive = true;
        }
    }
    function removeGameAddress(address gameAddress) external
    onlyOwner() {
        if (_games[gameAddress].isActive) {
            _games[gameAddress].isActive = false;
        }
    }

    // interface check
    function isDashboard() external pure returns (bool) {
        return true;
    }
}
