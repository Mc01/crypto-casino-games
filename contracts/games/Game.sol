pragma solidity >=0.5.0 <0.7.0;

import "../../node_modules/provable-eth-api/provableAPI.sol";

import "../../interfaces/IToken.sol";


contract Game is usingProvable {
    // abstract members
    function getNumRandomBytesRequested() internal returns (uint256);
    function getGasForCallback() internal returns (uint256);

    // abstract handler
    function handleSuccess(
        Bet memory,
        string memory
    ) internal;

    // members
    IToken internal _token;
    mapping (bytes32 => Bet) internal _bets;

    // bet model
    struct Bet {
        address player;
        uint256 stake;
        bool initialized;
    }

    // consts
    uint256 constant QUERY_EXECUTION_DELAY = 0;

    // events
    event LogNewProvableQuery(bytes32 queryId, address player, uint256 stake);
    event InvalidProvableQuery(bytes32 queryId, uint8 returnCode);
    event FailedProvableQuery(bytes32 queryId, string result, bytes proof, uint8 returnCode);
    event SucceddedProvableQuery(bytes32 queryId, string result);

    // Provable checker
    modifier onlyProvable() {
        require(
            msg.sender == provable_cbAddress(),
            "This method can be called only by Provable!"
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
        provable_setProof(proofType_Ledger);
    }

    // public entrypoint
    function play(address player, uint256 stake) external {
        bytes32 queryId = provable_newRandomDSQuery(
            QUERY_EXECUTION_DELAY,
            getNumRandomBytesRequested(),
            getGasForCallback()
        );
        _bets[queryId] = Bet(player, stake, true);
        emit LogNewProvableQuery(queryId, player, stake);
    }

    // Provable callback
    function __callback(
        bytes32 queryId,
        string memory result,
        bytes memory proof
    ) public
    onlyProvable() {
        Bet memory bet = _bets[queryId];
        uint8 returnCode = provable_randomDS_proofVerify__returnCode(queryId, result, proof);
        if (!bet.initialized) {
            emit InvalidProvableQuery(queryId, returnCode);
        }
        else if (returnCode != 0) {
            emit FailedProvableQuery(queryId, result, proof, returnCode);
        } else {
            emit SucceddedProvableQuery(queryId, result);
            handleSuccess(bet, result);
        }
    }

    // interface check
    function isGame() external pure returns (bool) {
        return true;
    }
}