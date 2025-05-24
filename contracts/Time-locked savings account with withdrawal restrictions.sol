// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TimeLockedSavings {
    struct Account {
        uint256 balance;
        uint256 unlockTime;
    }

    mapping(address => Account) private accounts;
    address public owner;

    event Deposit(address indexed accountHolder, uint256 amount, uint256 unlockTime);
    event Withdrawal(address indexed accountHolder, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Deposit funds with a time lock period (in seconds)
    function deposit(uint256 lockDurationInSeconds) external payable {
        require(msg.value > 0, "Deposit must be greater than zero");
        Account storage account = accounts[msg.sender];

        account.balance += msg.value;

        uint256 proposedUnlock = block.timestamp + lockDurationInSeconds;
        if (proposedUnlock > account.unlockTime) {
            account.unlockTime = proposedUnlock;
        }

        emit Deposit(msg.sender, msg.value, account.unlockTime);
    }

    // Withdraw funds only after unlock time
    function withdraw(uint256 amount) external {
        Account storage account = accounts[msg.sender];
        require(block.timestamp >= account.unlockTime, "Funds are still locked");
        require(amount <= account.balance, "Insufficient balance");

        account.balance -= amount;
        payable(msg.sender).transfer(amount);

        emit Withdrawal(msg.sender, amount);
    }

    // View account details
    function getAccount(address user) external view returns (uint256 balance, uint256 unlockTime) {
        Account storage account = accounts[user];
        return (account.balance, account.unlockTime);
    }
}
