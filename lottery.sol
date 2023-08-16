/*
Lottery Solidity Project

Works with Remix IDE + Metamask (testnet)

Constraints:
1) Minimum 3 participants should be there to start a lottery
2) Each participant must add atleast 2 ethers to contract address
Contract address isn't same as manager address
3) Transfering ethers in multiples of 2s isn't allowed, 
If participant wants to buy lottery tickets worth 12 ethers, 
participant has to transfer 2 ethers, 6 times 
(thus increasing chances of winning of that participant)
4) Only manager can check balance of contract i.e. lottery balance 
5) Only manager can call selectWinner function after which ethers from 
contract address will be transfered to winner's address
6) Manager can't participate in lottery

How lottery works?
Participants will participate in lottery & when manager selects a winner, 
all ethers in contract address are transferred in winner's address.

Metamask account of participants needn't have testnet ethers necessarily
They can have other testnet cryptocurrencies as well

By connecting to metamask wallet , one can see real time transactions happening,
i.e. the testnet cryptocurrencies getting transferred from one account to another

*/

//SPDX-License-Identifier:GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract lottery{
    address public manager;
    address payable[] public participants; 
    // why payable? if any one participant wins, money has to be transfered 

    constructor()
    {
        // 1st time jab deploy hoga to manager ke acc se karenge which will get stored
        // phir agar kisi aur account use karke deploy kiya toh msg.sender changes but address in manager remains same
        manager=msg.sender;  //global variable
    }

    //receive is a special type of function which can be used only once in contract, must have keywords external and payable
    receive() external payable
    {
        // require statement similar to if-else
        // only those particpants are allowed to participate who send minimum 2 wei
        require(msg.sender != manager); // manager can't participate in lottery
        require(msg.value == 1 ether);
        participants.push(payable(msg.sender));
    }

    /*
    The getBalance function in the given code returns the balance of the smart contract itself, not the balance of any specific address.
    In Solidity, address(this) refers to the address of the contract instance itself. So, when the getBalance function is executed, it will return the current balance (in wei) of the lottery contract. This balance includes any ether that has been sent to the contract through the receive function or any other means.
    */
    function getBalance() public view returns(uint)
    {
        // only manager should be able to see the balance of lottery, not the participants
        // 1st time jab deploy hoga to manager ke acc se karenge which will get stored
        // phir agar kisi aur account(eg. participant) use karke deploy kiya toh msg.sender changes but address in manager remains same
        require(msg.sender == manager);

        // the lines below require will only get executed if the condition is true
        // if it isn't it throws error
        return address(this).balance;
    }

    function getRandomNo() public view returns(uint)
    {
        // to generate random number
        // DON'T USE keccak for real life projects
        return uint(keccak256(abi.encodePacked( block.difficulty, block.timestamp, participants.length))); 
    }

    function selectWinner() public returns(address)
    {
        require(msg.sender == manager);
        require(participants.length>=3); //for lottery to start there should be minimum 3 participants
        uint r = getRandomNo();
        address payable winner;
        uint index = r % participants.length;
        winner = participants[index];
        winner.transfer(getBalance());

        // for resetting the contract after one winner has been selected
        participants = new address payable[](0); 

        return winner;
    } 
}
