const fs = require('fs');

const globalConfig = require('./config/global');


module.exports = async function(deployer) {
    console.log('Migrations started!');

    let skip = false;
    let fileExists = fs.existsSync(globalConfig.deploymentFile);
    let data;

    if (globalConfig.retryDeployment) {
        if (fileExists) {
            let content = fs.readFileSync(globalConfig.deploymentFile);
            data = JSON.parse(content);
            if (data.migration) skip = true;
        }
    }
    
    if (!skip) {
        let migrationContract = globalConfig.getMigrationContract(artifacts);
        await deployer.deploy(migrationContract);

        if (globalConfig.retryDeployment && fileExists) {
            data['migration'] = migrationContract.address;
        } else {
            data = {
                migration: migrationContract.address,
            }
        }
        fs.writeFileSync(globalConfig.deploymentFile, JSON.stringify(data));
    } else {
        console.log(`Skipping migrations. Already deployed under: ${data.migration}`);
    }
};
