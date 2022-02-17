//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 < 0.9.0;

contract Lottery {
    address payable[] public participants;
    address public manager;

    constructor(){
        manager = msg.sender;
    }

    receive () payable external{
        require(msg.value == 1 ether);
        participants.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint){
        require(msg.sender == manager);
        return address(this).balance;
    }

    function pickWinner() public view returns(address) {
        require(msg.sender == manager);
        require(participants.length>=3);
        uint random = uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length)));  
        address payable winner;
        uint index = random % participants.length;
        winner = participants[index];
        winner.transfer(getBalance());
        participants = new address payable[](0);
    }

}