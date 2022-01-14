//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Lottery{
    address payable[] public players;
    address public manager;

    constructor(){
        manager = msg.sender;
    }
    
    modifier onlyManager{
        require(msg.sender == manager);
        _;
    }

    receive() external payable{
        require(msg.value == 0.1 ether);
        players.push(payable (msg.sender));
    }

    function getBalance() public onlyManager view returns(uint){
        return address(this).balance;
    }

    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    error lotteryError(string _error);

    function pickWinner() public onlyManager {
        
        if(players.length < 3){
            revert lotteryError("Not enough players");
        }
        uint winner = random() % players.length;
        players[winner].transfer(getBalance());

        players = new address payable[](0);
    }

}