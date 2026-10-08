// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        //Before startBroadcast -> Not a real transaction
        HelperConfig helperConfig = new HelperConfig();

        address ethUSDPriceFeed = helperConfig.getActivePriceFeed();

        vm.startBroadcast(msg.sender); //After startBroadcast -> A real transaction

        FundMe fundMe = new FundMe(ethUSDPriceFeed);

        vm.stopBroadcast();

        return fundMe;
    }

    function getActivePriceFeed() external returns (address) {
        HelperConfig helperConfig = new HelperConfig();
        return helperConfig.getActivePriceFeed();
    }
}
