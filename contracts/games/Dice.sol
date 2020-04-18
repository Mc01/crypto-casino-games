pragma solidity >=0.5.0 <0.7.0;

import "./Game.sol";


contract Dice is Game {
        // const
    uint256 constant MAX_INT_FROM_BYTE = 256;
    uint256 constant NUM_RANDOM_BYTES_REQUESTED = 7;
    uint256 constant GAS_FOR_CALLBACK = 200000;

    // overriden abstract members
    function getNumRandomBytesRequested() internal returns (uint256) {
        return NUM_RANDOM_BYTES_REQUESTED;
    }
    function getGasForCallback() internal returns (uint256) {
        return GAS_FOR_CALLBACK;
    }

    // overriden abstract handler
    function handleSuccess(
        Bet memory bet,
        string memory result
    ) internal {
        uint256 ceiling = (MAX_INT_FROM_BYTE ** NUM_RANDOM_BYTES_REQUESTED) - 1;
        uint256 randomNumber = uint256(keccak256(abi.encodePacked(result))) % ceiling;
        if (randomNumber > 100) {
            _token.handleSuccess(bet.player, bet.stake);
        }
    }
}
