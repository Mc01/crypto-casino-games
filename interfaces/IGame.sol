pragma solidity >=0.5.0 <0.7.0;

interface IGame {
    function play(address, uint256, bytes32[] calldata) external;
    function isValidContext(bytes32[] calldata) external pure returns (bool);
    function isGame() external pure returns (bool);
}
