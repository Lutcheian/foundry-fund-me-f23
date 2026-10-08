// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe public fundMe;
    DeployFundMe public deployFundMe;

    address public USER = makeAddr("user");
    uint256 public constant SEND_VALUE = 0.1 ether;
    uint256 public constant STARTING_BALANCE = 10 ether;
    uint256 public constant GAS_PRICE = 1;

    receive() external payable {}

    function setUp() external {
        deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();

        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinimumDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.getOwner(), address(this));
    }

    function testPriceFeedVersionIsAccurate() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert(); //hey, the next line should revert!
        //assert(This tx fails/reverts)
        fundMe.fund(); //send 0 value
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER); //next tx will be sent from USER
        fundMe.fund{value: 10e18}(); //send 10 ETH
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, 10e18);
    }
    function testAddsFunderToArrayOfFunders() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }
    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawWithASingleFunder() public funded {
        //Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //Act
        vm.txGasPrice(GAS_PRICE);
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        //Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(
            startingFundMeBalance + startingOwnerBalance,
            endingOwnerBalance
        );
    }

    function testWithdrawFromMultipleFundersCheaper() public funded {
        //uinit160 is used to arrange number of funders, starting index, and loop through to fund the contract and it starts from 1 rather than 0 to avoid reverting the test due to the owner being at index 0.
        // The starting funder index is set to 1 to ensure that the owner is not included in the list of funders.
        //The loop iterates through the number of funders and uses the hoax function to simulate funding from different addresses.
        // The starting balances of the owner and the FundMe contract are recorded before the withdrawal, and after the withdrawal, assertions are made to ensure that the FundMe contract balance is zero and that the owner's balance has increased by the amount withdrawn from the contract.

        //Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;

        for (
            uint160 i = startingFunderIndex;
            i < numberOfFunders + startingFunderIndex;
            i++
        ) {
            //vm.prank(address(i)); //address(1), address(2), address(3)...
            hoax(address(i), SEND_VALUE); //deal + prank
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //Act
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        //Assert
        assert(address(fundMe).balance == 0);
        assert(
            startingFundMeBalance + startingOwnerBalance ==
                fundMe.getOwner().balance
        );
    }

    function testWithdrawFromMultipleFunders() public funded {
        //uinit160 is used to arrange number of funders, starting index, and loop through to fund the contract and it starts from 1 rather than 0 to avoid reverting the test due to the owner being at index 0.
        // The starting funder index is set to 1 to ensure that the owner is not included in the list of funders.
        //The loop iterates through the number of funders and uses the hoax function to simulate funding from different addresses.
        // The starting balances of the owner and the FundMe contract are recorded before the withdrawal, and after the withdrawal, assertions are made to ensure that the FundMe contract balance is zero and that the owner's balance has increased by the amount withdrawn from the contract.

        //Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;

        for (
            uint160 i = startingFunderIndex;
            i < numberOfFunders + startingFunderIndex;
            i++
        ) {
            //vm.prank(address(i)); //address(1), address(2), address(3)...
            hoax(address(i), SEND_VALUE); //deal + prank
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //Act
        vm.startPrank(fundMe.getOwner());
        fundMe.cheaperWithdraw();
        vm.stopPrank();

        //Assert
        assert(address(fundMe).balance == 0);
        assert(
            startingFundMeBalance + startingOwnerBalance ==
                fundMe.getOwner().balance
        );
    }
}
