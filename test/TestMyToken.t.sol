// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {MyToken} from "../src/MyToken.sol";
import {DeployMyToken} from "../script/DeployMyToken.s.sol";

contract TestMyToken is Test {
    MyToken myToken;
    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        DeployMyToken deployer = new DeployMyToken();
        myToken = deployer.run();
        console.log("MyToken deployed at:", address(myToken));
        console.log("deployer:", address(deployer));
        console.log("msg sender:", msg.sender);
        vm.prank(msg.sender);
        myToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public {
        assertEq(myToken.balanceOf(bob), STARTING_BALANCE);
    }

    function testAllowancesWorks() public {
        uint256 intialAllowance = 1000;
        // Bob approves Alice to spend his tokens on his behalf
        vm.prank(bob);
        myToken.approve(alice, intialAllowance);

        uint256 transferAmount = 500;
        vm.prank(alice);
        myToken.transferFrom(bob, alice, transferAmount);

        assertEq(myToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
        assertEq(myToken.balanceOf(alice), transferAmount);
    }
}