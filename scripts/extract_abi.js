const fs = require('fs');

console.log('Loading contract names from file.');

let content = fs.readFileSync('./scripts/contracts.json');
contracts = JSON.parse(content);

console.log(`Loaded following contract names: ${contracts}.`);

for (let i = 0; i < contracts.length; i++) {
    console.log(`Processing: ${contracts[i]}`);
    let buildContent = fs.readFileSync(`./build/contracts/${contracts[i]}.json`);
    let buildArtifact = JSON.parse(buildContent);
    let abi = buildArtifact.abi;
    fs.writeFileSync(`./abi/${contracts[i]}.json`, JSON.stringify(abi, null, '\t'));
    console.log(`Processed: ${contracts[i]}`);
}

console.log('Finishing ABI extraction.');
