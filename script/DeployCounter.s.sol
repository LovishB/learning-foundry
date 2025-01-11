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
To deploy this contract 
1) start anvil
2) run this with a) RPC url of local anvil and b) private key of anvil wallet
forge script script/DeployCounter.s.sol:DeployCounter --rpc-url http://localhost:8545 --broadcast --private-key PRIVATE_KEY
3) once deployed, check the transaction and address in broadcast dir
*/