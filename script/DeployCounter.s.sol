// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Script.sol"; //importing standard scripting lib
import "../src/Counter.sol"; //import contract 

contract DeployCounter is Script {
    
    //add a function to run and deploy the contract
    function run() external returns (Counter) {
        vm.startBroadcast();
        Counter counter = new Counter(); //deploying new contract
        vm.stopBroadcast();
        return counter;
    }
}

/*
To deploy this contract at anvil
1) start anvil
2) run this with a) RPC url of local anvil and b) private key of anvil wallet
forge script script/DeployCounter.s.sol:DeployCounter --rpc-url http://localhost:8545 --broadcast --private-key PRIVATE_KEY
3) once deployed, check the transaction and address in broadcast dir

To interact with contract
1) cast call 0x5FbDB2315678afecb367f032d93F642f64180aa3 "number()" --rpc-url 127.0.0.1:8545 
2) cast send 0x5FbDB2315678afecb367f032d93F642f64180aa3 "increment()" --rpc-url 127.0.0.1:8545 --private-key PRIVATE_KEY
3) cast send 0x5FbDB2315678afecb367f032d93F642f64180aa3 "setNumber()" 10 --rpc-url 127.0.0.1:8545 --private-key PRIVATE_KEY

To deplot on sepolia
forge script script/DeployCounter.s.sol:DeployCounter --rpc-url $RPC_URL_SEPOLIA --broadcast --private-key $PRIVATE_KEY --verify
cast call 0x45e2ec29256eed1d525602c88e526t884d1c03c1 "number()" --rpc-url $RPC_URL_SEPOLIA
cast send 0x45e2ec29256eed1d525602c88e526t884d1c03c1 "increment()" --rpc-url $RPC_URL_SEPOLIA --private-key $PRIVATE_KEY
*/