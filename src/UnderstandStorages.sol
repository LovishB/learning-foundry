// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/*
Explains different types of storage
- blockchain storage
- contract bytecode
- memory
- evm stack
*/
contract UnderstandStorages {

    // Storage variable - persists between transactions, most expensive gas-wise, stored on evm storage(each entry is of 32 bytes)
    // Best for: State that needs to persist
    uint256 public s_number;
    
    // Dynamic storage array - resizable, stored on blockchain evm storage (length is stored in 32 bytes and original data is hashed to a location)
    // Best for: Growing collections of data that need persistence
    uint256[] public s_numbers;
    
    // Constant - computed at compile time, no storage slot, it's stored in contract bytecode directly
    // Best for: Fixed values known at compile time
    uint256 public constant MAX_NUMBER = 100;
    
    // Immutable - set once in constructor, then read-only, it's stored in contract bytecode directly
    // Best for: Configuration values that are known at deployment
    uint256 public immutable INITIAL_VALUE;
    
    constructor(uint256 _initialValue) {
        INITIAL_VALUE = _initialValue;
    }

    function setNumber(uint256 newNumber) public {
        // Memory variable - temporary, exists only during function execution
        // Best for: Temporary calculations, cheaper than storage
        uint256[] memory tempArray = new uint256[](3);
        tempArray[0] = newNumber;
        
        s_number = tempArray[0];
        s_numbers.push(newNumber);

        // Stack variables - stored in EVM stack, limited to 16
        uint256 x = 1;
        uint256 y = 2;
        uint256 sum = x + y;
    }

    function increment() public {
        require(s_number < MAX_NUMBER, "Max limit reached");
        s_number++;
    }
}

/*
you can see how storage is layout
run forge inspect <contract name> storageLayout

example:
forge inspect FundMe storageLayout

╭--------------------+--------------------------------+------+--------+-------+-----------------------╮
| Name               | Type                           | Slot | Offset | Bytes | Contract              |
+=====================================================================================================+
| s_priceFeed        | contract AggregatorV3Interface | 0    | 0      | 20    | src/FundMe.sol:FundMe |
|--------------------+--------------------------------+------+--------+-------+-----------------------|
| s_funders          | address[]                      | 1    | 0      | 32    | src/FundMe.sol:FundMe |
|--------------------+--------------------------------+------+--------+-------+-----------------------|
| s_addressFundedMap | mapping(address => uint256)    | 2    | 0      | 32    | src/FundMe.sol:FundMe |
╰--------------------+--------------------------------+------+--------+-------+-----------------------╯
*/