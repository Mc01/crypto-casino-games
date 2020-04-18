/*

    Written with joy by https://github.com/Mc01
    - Slots game is the game about typical casino's slots

 */
pragma solidity >=0.5.0 <0.7.0;

import "./Game.sol";


contract Slots is Game {
    // const
    uint256 constant NUM_RANDOM_BYTES_REQUESTED = 24;
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
        /*

            Assumptions:
            - 24 required bytes
            - 0-255 range on 1 byte possible

            TODO:
            - may require more sophisticated random
            - 0-65K range on 2 bytes
            - 0-16M range on 3 bytes
            - What strategy for breakdown?

         */
        uint8[] memory randomNumbers;
        for (uint256 i = 0; i < NUM_RANDOM_BYTES_REQUESTED; i++) {
            randomNumbers[i] = 0;
        }
    }

    // context check
    function isValidContext() external pure
    returns (bool) {
        return true;
    }
}
