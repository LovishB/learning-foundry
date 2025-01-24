// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

//importing the Aggregator Contract Interface (ABI)
//@chainlink/contracts is npm package
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    //This tells solidity to attach type uint256 to library
    using PriceConverter for uint256;
    AggregatorV3Interface internal s_priceFeed;

    //imatable(set at deployment time) and constant(set at compile time) do not get store in storage
    address public immutable i_owner; //i_ for imutables
    uint256 public constant MINIMUM_USD = 5 * 1e18; //5 USD with 18 decimals

    //we need array + map approach as maps can't iterate in solidity
    address[] public s_funders; //s_ is for storage variables
    mapping(address => uint256) public s_addressFundedMap;

    /*
     Created a object with Interface(ABI) and address
     */
    constructor(address priceFeed) {
        s_priceFeed = AggregatorV3Interface(priceFeed);
        i_owner = msg.sender;
    }

    //User can send Eth(>5USD) to contract
    function fund() public payable {
        //checking the value > 5 USD else revert
        require(PriceConverter.getConversionRate(
            s_priceFeed, msg.value) >= MINIMUM_USD,
            "You need to spend more ETH!"
        );
        s_funders.push(msg.sender);
        s_addressFundedMap[msg.sender] = msg.value;
    }

    //owner can withdraw the balance of this contract which has been funded by other
    function withdraw() public onlyOwner {
        //looping on funders array
        for(uint256 i = 0; i<s_funders.length; i++) {
            address funder = s_funders[i];
            //reset funder on map
            s_addressFundedMap[funder] = 0;
        }
        //reseting funders array to a new array
        s_funders = new address[](0);

        //sender addresss here will be owner
        address senderAddress = msg.sender;
        //now we will send the entire balance of this contract to owner

        //three different ways to send fund from contract

        //1 transfer - it returns error if failed, max 2300 gas
        // payable(senderAddress).transfer(address(this).balance);

        //2 send - it return bool if failed, max 2300 gas
        // bool isSuccess = payable(senderAddress).send(address(this).balance);
        // require(isSuccess, "Send Failed");

        //3 call - low level call to function with send value, no capped gas
        (   bool callSuccess, 
            /* bytes dataReturned */
        ) = payable(senderAddress).call{value: address(this).balance}("");
        require(callSuccess, "Call Failed");

    }

    //Owner check Modifier
    modifier onlyOwner() {
        // require(msg.sender == owner, "Not Owner of Contract");
        // _;
        //more gas effecient
        if(msg.sender != i_owner) { revert NotOwner(); }
        _;
    }

    //What happens if someone send this contract money without calling fund function?
    //use recieve and fallback override functions and call fund() expeceitly
    receive() external payable { 
        fund();
    }  

    fallback() external payable {
        fund();
    }  

    // Ether is sent to contract
    //      is msg.data empty?
    //          /   \
    //         yes  no
    //         /     \
    //    receive()?  fallback()
    //     /   \
    //   yes   no
    //  /        \
    //receive()  fallback()

    function getAggregotorVersion() external view returns (uint256) {
        return PriceConverter.getAggregotorVersion(s_priceFeed);
    }

}

//Errors are more gas effecient than require
error NotOwner();