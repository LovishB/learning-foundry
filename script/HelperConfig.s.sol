//It is not recommended to hardcode addresses in deployment scripts
//That's why he make a new script for all network-configs

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol"; //importing standard scripting lib
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {

    uint8 public constant MOCK_DECIMALS = 8;
    int256 public constant INITIAL_MOCK_PRICE = 2000e8;

    //created a structure for better config specifications
    struct NetworkConfig {
        address priceFeed;
    }

    //in the constructor we check the chainID of block and return network config
    NetworkConfig public activeNetworkConfig;
    constructor() {
         if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainnetEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory){
        return NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
    }

    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
    }

    function getOrCreateAnvilConfig() public returns (NetworkConfig memory) {
        //first check if we already deplyed anvil price feed mock or not
        if(activeNetworkConfig.priceFeed != address(0)) { 
            return activeNetworkConfig;
        }
        //this is for mocking price feed in local testing
        //since price feed contract doesn't exist in local anvil
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            MOCK_DECIMALS, // decimals
            INITIAL_MOCK_PRICE // initial answer
        );
        vm.stopBroadcast();
        return NetworkConfig({
            priceFeed: address(mockPriceFeed) //returning mockPrice Feed
        });
    }
}
