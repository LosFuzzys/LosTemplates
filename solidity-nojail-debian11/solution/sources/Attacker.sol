// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./Challenge.sol";

contract Attacker
{
    Challenge target;

    constructor(address _target)
    {
        target = ChairLift(_target);
    }

    function attack() external
    {
        // Implement your Attack here
    }
}
