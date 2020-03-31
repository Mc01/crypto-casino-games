pragma solidity >=0.5.0 <0.7.0;

interface IDashboard {
    function gameIds(uint256) external view returns (address);
    function lastGameId() external view returns (uint256);
    function games(address) external view returns (uint256, address, bool);
    function isDashboard() external pure returns (bool);
}
