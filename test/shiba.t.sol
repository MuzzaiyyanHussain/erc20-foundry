//SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "forge-std/Test.sol";
import {console} from "forge-std/Test.sol";
import "../src/Shiba.sol";

contract ShibaTest is Test {
    event Transfer(address indexed from, address indexed to, uint256 value);

    Shiba shib;

    function setUp() public {
        shib = new Shiba();
    }

    function testMint() public {
        shib.mint(address(this), 1000);
        shib.mint(0x949659b4D8CCb37599e80708ACa404E4291cD0eC, 1);
        assertEq(shib.balanceOf(address(this)), 1000);
        assertEq(shib.balanceOf(0x949659b4D8CCb37599e80708ACa404E4291cD0eC), 1);
    }

    function testTransfer() public {
        shib.mint(address(this), 100);
        shib.transfer(0x949659b4D8CCb37599e80708ACa404E4291cD0eC, 50);
        assertEq(shib.balanceOf(0x949659b4D8CCb37599e80708ACa404E4291cD0eC), 50);
        vm.prank(0x949659b4D8CCb37599e80708ACa404E4291cD0eC);
        shib.transfer(0x16b580296b5928DcD872B19B48c43A23f242758d, 2);
        assertEq(shib.balanceOf(0x16b580296b5928DcD872B19B48c43A23f242758d), 2);
    }

    function testTotalSupply() public {
        shib.mint(address(this), 1000);
        shib.mint(address(this), 1);
        assertEq(shib.totalSupply(), 1001);
    }

    function testApproveFrom() public {
        shib.mint(address(this), 100);
        shib.approve(0x16b580296b5928DcD872B19B48c43A23f242758d, 10);
        vm.prank(0x16b580296b5928DcD872B19B48c43A23f242758d);
        shib.transferFrom(address(this), 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266, 10);
        assertEq(shib.balanceOf(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266), 10);
    }
    //Negative tests

    function test_RevertWhen_NotApproved() public {
        shib.mint(address(this), 100);

        vm.prank(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        vm.expectRevert(
            abi.encodeWithSignature(
                "ERC20InsufficientAllowance(address,uint256,uint256)", 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266, 0, 1
            )
        );
        shib.transferFrom(address(this), 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266, 1);
    }

    function testTransferEmits() public {
        shib.mint(address(this), 1000);
        vm.expectEmit(true, true, false, true);
        emit Transfer(address(this), 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266, 100);
        shib.transfer(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266, 100);
        console.logAddress(address(this));
    }

    function testDealExample() public {
        address account = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        vm.deal(account, 10 ether);
        assertEq(address(account).balance, 10 ether);
    }
}
