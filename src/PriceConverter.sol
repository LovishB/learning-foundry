// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {

//Function return price of ETH/USD from dataFeed
    function getPrice(AggregatorV3Interface dataFeed) internal view returns (uint256) {
        // Get ETH/USD price from Chainlink
        (
            /* uint80 roundID */,
            int256 price,
            /* uint startedAt */,
            /* uint timeStamp */,
            /* uint80 answeredInRound */
        ) = dataFeed.latestRoundData();

        // Chainlink price comes with 8 decimals, convert to 18 to match Wei
        return uint256(price) * 1e10;
    }

    //Converts ETH to USD
    function getConversionRate(AggregatorV3Interface dataFeed, uint256 ethAmount) internal view returns (uint256) {
        uint256 ethUsdPrice = getPrice(dataFeed); //getting lastest eth price
        uint256 ethAmountInUsd = (ethUsdPrice * ethAmount) / 1e18; //we adjust the decimal here
        return ethAmountInUsd;
    }

    function getAggregotorVersion(AggregatorV3Interface dataFeed) internal view returns (uint256) {
        return dataFeed.version();
    }

}