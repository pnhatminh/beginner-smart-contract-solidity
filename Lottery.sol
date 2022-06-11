// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

contract Lottery {
    address public owner;
    address payable[] public players;
    uint public lotteryId;
    mapping(uint => address payable) public lotteryWinningHistory;

    constructor() {
        owner = msg.sender;
        lotteryId = 1;
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }

    function getWinnerByLotteryId(uint _lotteryId) public view returns (address payable) {
        return lotteryWinningHistory[_lotteryId];
    }   

    function enter() public payable {
        require(msg.value > .01 ether, "You must purchase at least 0.01 ether for entering the lottery");
        // address of player entering the lottery
        players.push(payable(msg.sender));
    }

    function getRandomNumber() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }

    function pickWinner() public onlyOwner { 
        uint index = getRandomNumber() % players.length;
        players[index].transfer(address(this).balance);
        lotteryWinningHistory[lotteryId] = players[index];
        lotteryId++;
        // reset the state of the contract
        players = new address payable[](0);
        
    }

    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }
}
