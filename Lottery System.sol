// SPDX-License-Identifier: MIT
//LoneWolf
pragma solidity ^0.8.0;

contract SimpleLottery {
    address public manager;
    address[] public players;

    constructor() {
        manager = msg.sender;
    }

    function buyTicket() public payable {
        require(msg.value >= 0.0001 ether, "Minimum ticket price is 0.0001 ether");
        players.push(msg.sender);
    }

    function random() private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
    }

    function pickWinner() public restricted {
        require(players.length > 0, "No players in the lottery");

        uint256 index = random() % players.length;
        address winner = players[index];
        uint256 contractBalance = address(this).balance;

        payable(winner).transfer(contractBalance);
        players = new address[](0);
    }

    modifier restricted() {
        require(msg.sender == manager, "Only the manager can call this function");
        _;
    }

    function getPlayers() public view returns (address[] memory) {
        return players;
    }
}
