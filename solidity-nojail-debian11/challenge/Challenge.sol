// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract ChallengeContract
{
    address owner;
    mapping(address => uint) public balances;

    constructor()
    {
        owner = msg.sender;
    }

    //This is the function you need to call to buy tokens

    function buy() public payable
    {
        _mint(msg.value, msg.sender);
    }
    
    //Internal functions (These shouldn't interest you)
    function _mint(uint256 amount, address target) internal
    {
        balances[target] += amount;
    }
}