//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Lottery{
    address payable[] public players;
    address public manager;

    constructor(){
        manager = msg.sender;
    }
    

    receive() external payable{
        require(msg.value == 0.1 ether);
        players.push(payable (msg.sender));
    }

    function getBalance() public view returns(uint){
        require(msg.sender == manager);
        return address(this).balance;
    }

    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    function pickWinner() public {
        require(msg.sender == manager);
        require(players.length > 3);

        uint winner = random() % players.length;
        players[winner].transfer(getBalance());
        
        players = new address payable[](0);
    }

}