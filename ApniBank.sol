// SPDX-License-Identifier: GPL-3.0
// the account that deploys this banking contract belongs to ApniBank, i.e owner is ApniBank
// as a welcome offer for customers initially Apni Bank deposits some gift funds in accounts of customers
// customers can checkBalance, transerFunds, withdrawFunds

pragma solidity >=0.8.2 <0.9.0;

contract ApniBank{
    // for holding balances we define mapping
    mapping(address=>uint) balances;
    address owner;

    constructor(){
        owner = msg.sender;
    }

    // only bank should be able to deposit funds to other accounts(like 3rd party application to transfer funds)
    modifier onlyowner(address _addr)
    {
        require(_addr == owner , "Only I can send or withdraw money from my account");
        _;
    }

    // function for ApniBank to deposit initial funds into given address
    // initially bank has welcome offer & thus deposits funds into customers account
    function depositFundsByApniBank(address _addr, uint _funds) public onlyowner(msg.sender){
        require(_funds > 0 , "Amount to be sent can't be <=0");
        balances[_addr] += _funds;
    }

    // function so that customer can check balance who calls this function
    function checkBalance() public view returns(uint){
        return balances[msg.sender];
    }

    // function to withdraw funds by customer who calls this funstion
    function withdrawFundsByApniBank(uint _funds) public {
        require(_funds > 0 , "Amount to be withdrawn can't be <=0");
        require(balances[msg.sender] >= _funds, "Withdrawer has insufficient balance");
        balances[msg.sender]-= _funds;
    }

    // function so that user calling this function after contract has been deployed can send funds without intervention of bank provided it has sufficint balance
    // no need of modifier onlyowner
    function transferFundsByCustomer( address _receiverAddr, uint _funds) public{
        require(_funds > 0 , "Amount to be sent can't be <=0");
        require(balances[msg.sender] >= _funds, "Sender has insufficient balance");
        balances[msg.sender] -= _funds;
        balances[_receiverAddr] += _funds;
    }
}


