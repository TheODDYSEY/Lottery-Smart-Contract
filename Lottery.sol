// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

contract Lottery {
    // State variables
    address public owner; // Owner of the contract
    address payable[] public players; // Array of players participating in the lottery
    uint public lotteryId; // ID of the current lottery
    mapping (uint => address payable) public lotteryHistory; // Mapping to store the history of lottery winners

    // Constructor to initialize the contract
    constructor() {
        owner = msg.sender; // Set the owner to the address that deploys the contract
        lotteryId = 1; // Initialize the lottery ID to 1
    }

    // Function to get the winner of a specific lottery by ID
    function getWinnerByLottery(uint lottery) public view returns (address payable) {
        return lotteryHistory[lottery];
    }

    // Function to get the balance of the contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    // Function to get the list of players in the current lottery
    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }

    // Function for a player to enter the lottery
    function enter() public payable {
        require(msg.value > .01 ether); // Require a minimum amount of ether to enter

        // Add the address of the player entering the lottery
        players.push(payable(msg.sender));
    }

    // Function to generate a pseudo-random number
    function getRandomNumber() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(owner, block.timestamp))); // Generate a random number using keccak256
    }

    // Function to pick a winner from the players
    function pickWinner() public onlyowner {
        uint index = getRandomNumber() % players.length; // Get a random index of the players array
        players[index].transfer(address(this).balance); // Transfer the contract balance to the winner

        lotteryHistory[lotteryId] = players[index]; // Store the winner in the lottery history
        lotteryId++; // Increment the lottery ID
        
        // Reset the state of the contract
        players = new address payable[](0); // Clear the players array
    }

    // Modifier to restrict access to owner-only functions
    modifier onlyowner() {
      require(msg.sender == owner); // Require that the caller is the owner
      _; // Continue with the function execution
    }
}