var HDWalletProvider = require('truffle-hdwallet-provider-privkey');
const DotEnv = require('dotenv');

DotEnv.config();
var privkey = [process.env.PRIV_KEY];

var infuraToken = process.env.INFURATOKEN;

function gwei(n) { return n * (10 ** 9); }
function mwei(n) { return n * (10 ** 6); }

const gasLimit = mwei(6);
const gasPrice = gwei(20);

module.exports = {
    networks: {
        ganache: {
            host: "ganache_node",
            port: 7545,
            network_id: "*",
        },
        coverage: {
            host: "ganache_node",
            port: 8545,
            network_id: "*",
            gas: 0xfffffffffff,
            gasPrice: 0x01,
        },
        ropsten: {
            network_id: 3, // Official ropsten network id 
            provider: () => new HDWalletProvider(privkey, `https://ropsten.infura.io/v3/${infuraToken}`),
            gas: gasLimit,
            gasPrice: gasPrice,
            skipDryRun: true,
        },
        kovan: {
            network_id: 42, // Official kovan network id
            provider: () => new HDWalletProvider(privkey, `https://kovan.infura.io/v3/${infuraToken}`),
            gas: gasLimit,
            gasPrice: gasPrice,
            skipDryRun: true,
        },
        rinkeby: {
            network_id: 4, // Official rinkeby network id
            provider: () => new HDWalletProvider(privkey, `https://rinkeby.infura.io/v3/${infuraToken}`),
            gas: gasLimit,
            gasPrice: gasPrice,
            skipDryRun: true,
        },
        mainnet: {
            network_id: 1, // Official main network id
            provider: () => new HDWalletProvider(privkey, `https://mainnet.infura.io/v3/${infuraToken}`),
            gas: gasLimit,
            gasPrice: gasPrice,
        },
    },
    mocha: {
        reporter: 'eth-gas-reporter',
    },
    compilers: {
        solc: {
            version: '^0.5.16',
        },
    },
};
