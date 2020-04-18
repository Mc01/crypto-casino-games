/*

    Written with joy by https://github.com/Mc01
    - Dice game is the game about 4 dices - called eggs in the code

 */
pragma solidity >=0.5.0 <0.7.0;

import "./Game.sol";


contract Dice is Game {
    // const
    uint256 constant NUM_RANDOM_BYTES_REQUESTED = 2;
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

            This game aims to find out what are the values o 4 eggs

            When we concat numbers of each egg, like following:
            - egg no. 1 is 5
            - egg no. 2 is 3
            - egg no. 3 is 2
            - egg no. 4 is 1
            The result would be seqeunce 5321

            ---

            Game flow is as following:

            - user sets value of risk
            -> which is the number between 0 and 9999
            --> lower the number -> smaller chance to win and bigger reward
            --> higher the number -> higher chance to win and smaller reward
            -> eggs max value is 9999, so:
            --> number 10 would give 10/9999 chances to win and big reward
            --> number 9000 would give 9000/9999 chances to win and small reward

            - user sets value of stake
            -> number of Casino Tokens set as stake
            -> which are hold securely on Vault contract
            -> in case of win:
            --> user receives reward based on stake * risk
            -> in case of loose:
            --> stake is kept in Vault contract

            - user sends transaction with stake's value of Casino Tokens and risk

            - random number is generated using Provable
            -> function getNumRandomBytesRequested returns 2 bytes
            --> for this game we require 10,000 combinations
            --> 2 bytes ensures 256^2 => 65,536 possible combinations

            - reward is sent or stake is kept depended on values of risk and random

            ---

            params:
            > bet - game state
            > result - random bytes from Provable

         */
        uint256 ceiling = (MAX_INT_FROM_BYTE ** NUM_RANDOM_BYTES_REQUESTED) - 1;
        uint16 randomNumber = uint16(
            uint256(keccak256(abi.encodePacked(result))) % ceiling
        );

        uint256 risk = uint256(bet.context[0]);

        /*

            TODO:
            - How to calculate reward?

         */
        if (risk < randomNumber) {
            uint256 reward = randomNumber - risk;
            _token.handleSuccess(bet.player, reward);
        }
    }

    // context check
    function isValidContext(bytes32[] calldata context) external pure
    returns (bool) {
        if (context.length == 1) {
            uint256 value = uint256(context[0]);
            return 0 < value && value < 10000;
        }
        return false;
    }
}
