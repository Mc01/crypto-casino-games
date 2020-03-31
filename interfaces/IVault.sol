pragma solidity >=0.5.0 <0.7.0;

interface IVault {
    function sendReward(address, uint256) external;
    function isVault() external pure returns (bool);
}
