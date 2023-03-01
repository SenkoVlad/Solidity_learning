//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract AuctionEngine {
    address public owner;
    uint constant DURATION = 2 days;
    uint constant FEE = 10;
    Auction[] public auctions;

    event AuctionCreated(uint index, string itemName, uint startPrice, uint duration);
    event AuctionEnded(uint index, uint endPrice, address winner);

    struct Auction {
        address payable seller;
        uint startPrice;
        uint endPrice;
        uint startsAt;
        uint endsAt;
        uint discountRate;
        string item;
        bool isStooped;
    }

    constructor() {
        owner = msg.sender;
    }

    function createAuction(uint _startPrice, uint _discountRate, string calldata _item, uint _duration) external {
        uint duration = _duration == 0 
            ? DURATION 
            : _duration;

        require(_startPrice >= _discountRate * duration, "startPrice is less than _discountRate * duration");

        Auction memory newAuction = Auction({
            seller: payable(msg.sender),
            startPrice: _startPrice,
            endPrice: _startPrice,
            discountRate: _discountRate,
            startsAt: block.timestamp,
            endsAt: block.timestamp + duration,
            item: _item,
            isStooped: false
        });
        auctions.push(newAuction);        
        emit AuctionCreated(auctions.length - 1, _item, _startPrice, duration);
    }

    function getPriceFor(uint index) public view returns(uint) {
        Auction memory currentAuction = auctions[index];
        require(!currentAuction.isStooped, "Auction is stopped");
        uint elapsed = block.timestamp - currentAuction.startsAt;
        uint discount = currentAuction.discountRate * elapsed;
        return currentAuction.startPrice - discount;
    }

    function buy(uint index) external payable {
        Auction storage currentAuction = auctions[index];
        require(!currentAuction.isStooped, "Auction is stopped");
        require(block.timestamp < currentAuction.endsAt, "Auction is ended");
        uint currentPrice = getPriceFor(index);
        require(msg.value >= currentPrice, "not enough price to buy");
        currentAuction.isStooped = true;
        currentAuction.endPrice = currentPrice;
        uint refund = msg.value - currentPrice;
        
        if (refund > 0) {
            payable(msg.sender).transfer(refund);
        }
        currentAuction.seller.transfer(
            currentPrice - (currentPrice * FEE) / 100
        );

        emit AuctionEnded(index, currentPrice, msg.sender);
    }
}