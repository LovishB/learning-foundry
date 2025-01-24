// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol"; //importing standard testing lib
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user"); //this is a feature of foundry to create a new user & use to make txs

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

    function testNoEthToFund() public {
        vm.expectRevert(); //expect a revert from contract call as if do not meet the require check
        fundMe.fund();
    }

    function testNotEnoughEthToFund() public {
        vm.expectRevert();
        fundMe.fund{value: 10e10}();
    }

    function testAddressFundedMap() public {
        fundMe.fund{value: 10e18}();
        assertEq(fundMe.s_addressFundedMap(address(this)), 10e18);
    }

    function testAddressFundedMapUser() public {
        vm.prank(USER); //this means that the next TX will be send by User created for testing and not the test contract(address(this))
        vm.deal(USER, 10e19); //this will add some money in USER account

        fundMe.fund{value: 10e18}();
        assertEq(fundMe.s_addressFundedMap((USER)), 10e18);
    }

    //instead of same code in each test, we can just call modifier and save code
    modifier fundUser() {
        vm.prank(USER);
        vm.deal(USER, 10e19);
        fundMe.fund{value: 10e18}();
        _;
    }

    function testFundersArray() public fundUser {
        assertEq(fundMe.s_funders(0), USER);
    }

    function testOnlyTheOwnerCanWithdraw() public fundUser {
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdraw() public fundUser {
        //user has funded the contract already (check modifier)
        uint256 startingOwnerBalance = fundMe.i_owner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.prank(fundMe.i_owner()); //next transacrtion is done by owner
        fundMe.withdraw();

        uint256 endingOwnerBalance = fundMe.i_owner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        assertEq(endingFundMeBalance, 0);
        assertEq(endingOwnerBalance, startingFundMeBalance + startingOwnerBalance);
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

/* snapshot run cmd :
forge snapshot --match-test "<test name>"
this will give the gas calculation
*/