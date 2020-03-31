pragma solidity >=0.5.0 <0.7.0;

interface IToken {
    function handleSuccess(address, uint256) external;
    function isToken() external pure returns (bool);
}
