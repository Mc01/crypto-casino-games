const DotEnv = require('dotenv');
DotEnv.config();


class GlobalConfig {
    constructor() {
        this.keepDeployedFile = process.env.KEEP_DEPLOYED;
        this.retryDeployment = process.env.RETRY_DEPLOYMENT == 'true';
    }

    get deploymentFile() {
        if (this.keepDeployedFile) {
            return './.deployed';
        } else {
            return '/tmp/.deployed';
        }
    }

    delay(ms) {
        return new Promise(res => setTimeout(res, ms));
    } 

    async retryUntilSuc(callback) {
        let stop = 3;
        while (stop > 0) {
            try {
                await callback();
                return;
            } catch (e) {
                console.log('Failed, retrying...');
                await this.delay(5000);
                stop--;
            }
        }
    }

    etherInWei(ether) {
        return (ether * 10**18).toString();
    }

    tokenInDecimals(token) {
        // TODO: To be adjusted to external configurable decimals if needed
        return (token * 10**18).toString();
    }

    getContract(artifacts, contractName) {
        return artifacts.require(`./${contractName}.sol`);
    }

    getMigrationContract(artifacts) {
        return this.getContract(artifacts, 'Migrations');
    }
}

module.exports = new GlobalConfig();
