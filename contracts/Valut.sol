pragma solidity >=0.5.0 <0.7.0;

import "../node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "../interfaces/IToken.sol";
import "../interfaces/IVault.sol";


contract Valut is IVault {
    // members
    IToken private _token;

    // vault access
    modifier onlyToken() {
        require(
            msg.sender == address(_token),
            "Sender is not a game or does not have access!"
        );
        _;
    }

    // initializer
    constructor(address tokenAddress) public {
        IToken token = IToken(tokenAddress);
        require(
            token.isToken(),
            "Given address is not a token contract!"
        );
        _token = token;
    }

    // token controllers
    function sendReward(address recipient, uint256 amount) external
    onlyToken() {
        IERC20 token = IERC20(address(_token));
        token.transfer(recipient, amount);
    }

    // interface check
    function isVault() external pure returns (bool) {
        return true;
    }
}
