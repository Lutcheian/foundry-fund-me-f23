// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundme, WithdrawFundme} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() external {
        DeployFundMe deploy = new DeployFundMe();
        fundMe = deploy.run();

        vm.deal(USER, STARTING_BALANCE);
    }

    function testUserCanFundInteractions() public {
        vm.prank(USER);

        fundMe.fund{value: SEND_VALUE}();

        address funder = fundMe.getFunder(0);

        assertEq(funder, USER);
    }
}
