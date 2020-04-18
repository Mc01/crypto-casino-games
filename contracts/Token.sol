pragma solidity >=0.5.0 <0.7.0;

import "../node_modules/@openzeppelin/contracts/ownership/Ownable.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";

import "../interfaces/IDashboard.sol";
import "../interfaces/IGame.sol";
import "../interfaces/IToken.sol";
import "../interfaces/IVault.sol";


contract Token is ERC20Detailed, ERC20, Ownable, IToken {
    // members
    IDashboard private _dashboard;
    IVault private _vault;

    // getters
    function dashboard() external view returns (address) {
        return address(_dashboard);
    }
    function vault() external view returns (address) {
        return address(_vault);
    }

    // init checker
    modifier onlyAfterInit() {
        require(
            address(_dashboard) != address(0x0),
            "Dashboard is not initialized!"
        );
        require(
            address(_vault) != address(0x0),
            "Vault is not initialized!"
        );
        _;
    }

    // initializer
    constructor(
        string memory theName,
        string memory theSymbol,
        uint8 theDecimals
    ) public
    ERC20Detailed(theName, theSymbol, theDecimals)
    Ownable() {}

    // setters
    function setDashboard(address dashboardAddress) external
    onlyOwner() {
        IDashboard dashboardCandidate = IDashboard(dashboardAddress);
        require(
            dashboardCandidate.isDashboard(),
            "Given address is not a Dashboard contract!"
        );
        _dashboard = dashboardCandidate;
    }
    function setVault(address vaultAddress) external
    onlyOwner() {
        IVault vaultCandidate = IVault(vaultAddress);
        require(
            vaultCandidate.isVault(),
            "Given address is not a Vault contract!"
        );
        _vault = vaultCandidate;
    }

    // game checker
    function validateGame(address gameAddress) internal view
    returns (IGame) {
        IGame game = IGame(gameAddress);
        require(
            game.isGame(),
            "Adress is not a game contract!"
        );
        (
            uint256 id,
            address instanceAddress,
            bool hasAccess
        ) = _dashboard.games(gameAddress);
        require(
            id > 0,
            "Id of initialized game should be greater than 0!"
        );
        require(
            instanceAddress == gameAddress,
            "Address in storage should be equal to provided game address!"
        );
        require(
            hasAccess,
            "Game should be active!"
        );
        return game;
    }

    // public entrypoint, inspired by ERC827->transferAndCall
    function transferAndCall(
        uint256 amount,
        address gameAddress,
        bytes32[] calldata context
    ) external
    onlyAfterInit() {
        /*

            Workflow for transfer and call is like this:

            - Token validates Game address

            - Token checks permissions and provided context
            -> Context is just a list of parameters
            -> For example:
            --> argument [ bytes32(uint256(5000)) ]
            --> will be decoded to number 5000 in function handleSuccess() for Dice game
            -> Context is validated with Game's function isValidContext()

            - Stake is transferred to Vault for game time
            -> Vault is safe on-chain storage contract
            -> Vault holds Casino Tokens and sends reward in case of won game

            - Game is started and call to Provable is initiated
            -> Number of bytes in each game determines how big random would be returned

            - Provable invokes callback function for Game with supplied random number

            - Game logic processes random number and calls handleSuccess() function if game is won

        */
        IGame game = validateGame(gameAddress);
        if (!game.isValidContext(context)) {
            revert("Game context is not valid!");
        }
        transfer(address(_vault), amount);
        game.play(msg.sender, amount, context);
    }

    // callable from game contract; callback method for handling success
    function handleSuccess(address player, uint256 amount) external
    onlyAfterInit() {
        validateGame(msg.sender);
        if (amount > 0) {
            _vault.sendReward(player, amount);
        }
    }

    // interface check
    function isToken() external pure returns (bool) {
        return true;
    }
}
