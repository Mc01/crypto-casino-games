/*

    Written with joy by https://github.com/Mc01
    - This one is about abstract Game contract

 */
pragma solidity >=0.5.0 <0.7.0;

import "../../node_modules/provable-eth-api/provableAPI.sol";

import "../../interfaces/IGame.sol";
import "../../interfaces/IToken.sol";


contract Game is usingProvable, IGame {
    // abstract members
    /*

        For extending this abstract contract check docstrings for:
            - function play(address player, uint256 stake)
            - children's - function handleSuccess(Bet memory bet, string memory result)

     */
    function getNumRandomBytesRequested() internal returns (uint256);
    function getGasForCallback() internal returns (uint256);
    function isValidContext(bytes32[] calldata) external pure returns(bool);
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
        bytes32[] context;
        bool initialized;
    }

    // consts
    uint256 constant QUERY_EXECUTION_DELAY = 0;
    uint256 constant MAX_INT_FROM_BYTE = 256;

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
    modifier onlyToken() {
        require(
            msg.sender == address(_token),
            "This method can be called only by Token!"
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
    function play(
        address player,
        uint256 stake,
        bytes32[] calldata context
    ) external
    onlyToken() {
        /*

            Argument: getNumRandomBytesRequested

            NUM_BYTES   =>      BITS            =>      DECIMALS
            1 byte      =>      256 ** 1        =>      256
            2 bytes     =>      256 ** 2        =>      65,536
            3 bytes     =>      256 ** 3        =>      16 * 10 ** 6
            4 bytes     =>      256 ** 4        =>      4 * 10 ** 9
            5 bytes     =>      256 ** 5        =>      1 * 10 ** 12
            6 bytes     =>      256 ** 6        =>
            7 bytes     =>      256 ** 7        =>      72 * 10 ** 15

            Provable accepts number of bytes between 1 and 32

            32 bytes    =>      256 ** 32       =>      115 * 10 ** 75

            ----

            Uint256 size is 32 bytes
            Accepted values are between 0 and 256 ** 32 - 1

            Example:
              > For random number between 0 - 10,000
              -> Two bytes (256 ** 2) are enough

              > For random number between 0 - 1M
              -> Three bytes (256 ** 3) are enough

            ----

            For individual games' implementation check their docstings

         */
        bytes32 queryId = provable_newRandomDSQuery(
            QUERY_EXECUTION_DELAY,
            getNumRandomBytesRequested(),
            getGasForCallback()
        );
        _bets[queryId] = Bet(player, stake, context, true);
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