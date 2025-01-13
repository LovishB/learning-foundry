// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol"; //importing standard testing lib
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    // runs first, and deploys contract on temperory anvil chain
    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe(); //calling script to deploy fund me contract
        fundMe = deployFundMe.run();
    }

    function testMinIsFiveUsd() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testAggregotorVersion() public view {
        assertEq(fundMe.getAggregotorVersion(), 4);
    }
}

/*
Common types of testing in foundry
1) Local Unit Testing (70-80% of test)
Command: forge test, 
best for testing individual functions and components

2) Fork Test(15-20%)
Run against a fork of mainnet/testnet
Command: forge test --fork-url $MAINNET_RPC_URL

3) Integration/Staging Test(5-10%)
Least common, runs on actual testnet before deployment
Most expensive and slowest
*/