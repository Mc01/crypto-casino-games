pragma solidity >=0.5.0 <0.7.0;

interface IGame {
    function play(address, uint256) external;
    function isGame() external pure returns (bool);
}
