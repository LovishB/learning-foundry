// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol"; //importing standard scripting lib
import {FundMe} from "../src/FundMe.sol"; //import contract 
import {HelperConfig} from "./HelperConfig.s.sol"; //importing networks

contract DeployFundMe is Script {

    //add a function to run and deploy the contract
    function run() external returns (FundMe) {
        //Anything before broadcast is not a real 'tx'
        HelperConfig helperConfig = new HelperConfig(); //deploying in temporary env as we don't want it deployed for gas usage
        (address priceFeed) = helperConfig.activeNetworkConfig();

        vm.startBroadcast();
        FundMe fundMe = new FundMe(priceFeed); //deploying new contract
        vm.stopBroadcast();
        return fundMe;
    }
}