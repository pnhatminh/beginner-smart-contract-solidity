// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

contract VendingMachine {
    address public owner;
    mapping (address => uint) public donutBalances;

    constructor () {
        owner = msg.sender;
        donutBalances[address(this)] = 100;
    }

    function getVendingMachineBalance() public view returns (uint) {
        return donutBalances[address(this)];
    }

    function restock(uint amount) public payable {
        require(msg.sender == owner, "Only the owner can restock this vending machine.");
        require(msg.value == amount * 2, "You must pay 2 ether per donut to restock.");
        donutBalances[address(this)] += amount;
    }

    function purchase(uint amountOfDonut) public payable {
        require(msg.value == amountOfDonut * 3 ether, "You must pay at least 3 ether per donut");
        require(donutBalances[address(this)] >= amountOfDonut, "Not enough donut in stock to fulfill your request");
        donutBalances[address(this)] -= amountOfDonut;
        donutBalances[msg.sender] += amountOfDonut;
    }
}
