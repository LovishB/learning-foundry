// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

/*
Integration tests 
- complete workflows (fund -> withdraws)
- contract to interactions
- multiple user interactions
*/
contract FundMeIntegrationTest is Test {
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        DeployFundMe deployer = new DeployFundMe();
        fundMe = deployer.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testUserCanFundAndOwnerWithdraw() public {
        // Arrange
        vm.prank(USER);
        vm.txGasPrice(GAS_PRICE);

        // Act - Fund
        fundMe.fund{value: SEND_VALUE}();

        // Assert funding
        assertEq(address(fundMe).balance, SEND_VALUE);
        assertEq(fundMe.s_addressFundedMap(USER), SEND_VALUE);

        // Act - Withdraw
        vm.prank(fundMe.i_owner());
        fundMe.withdraw();

        // Assert withdrawal
        assertEq(address(fundMe).balance, 0);
        assertEq(fundMe.s_addressFundedMap(USER), 0);
    }

    function testMultipleUsersFundAndOwnerWithdraws() public {
        // Arrange
        uint8 numberOfFunders = 10;
        uint256 startingFunderIndex = 1;

        // Act - Multiple users fund
        for(uint256 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(uint160(i)), STARTING_BALANCE);
            fundMe.fund{value: SEND_VALUE}();
        }

        // Assert multiple fundings
        assertEq(address(fundMe).balance, SEND_VALUE * (numberOfFunders - 1));
        
        // Act - Owner withdraws
        vm.startPrank(fundMe.i_owner());
        fundMe.withdraw();
        vm.stopPrank();

        // Assert after withdrawal
        assertEq(address(fundMe).balance, 0);
        for(uint256 i = startingFunderIndex; i < numberOfFunders; i++) {
            assertEq(fundMe.s_addressFundedMap(address(uint160(i))), 0);
        }
    }

}