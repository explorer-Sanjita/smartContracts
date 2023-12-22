// election voting blockchain based system smart contract
// this contract lays foundation for DAOs
// implemented in IDS Blockchain Bootcamp
// owner of the contract is election committee which deploys this contract
// for this contract only 3 candidates can stand for election ( candidateCount = 3 )
// Voter can cast vote only once (voteOrNot mapping) 
// Voter can vote only from 3 existing candidates, i.e voting for candidate having ID>3 isn't allowed
// this contract handles draw between candidates as well
// candidates can only be added 1 day after 1st candidate has been registered
// after 1s day ,voters can vote only within certain time frame, here 2 days after the 1st candidate registers
// this election gets completed in 3 days




// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract ApniSarkar{
    address owner;
    uint candidateCount;
    uint candidateID; // can take values 1,2,3 only since only 3 candidates allowed
    uint start;
    uint durationOfCandidateRegistration = 1 days;
    uint durationOfElection = 2 days;


    // struct for candidates who are standing for election
    struct candidate{
        uint id; 
        string name;
        uint voteCount;
    }
    // mapping to check whether a voter corresponding to given address hasvoted or not
    mapping(address => bool) votedOrNot;

    // mapping for pointing candidate based on thier IDs
    // we can also use this mapping to find just the vote count of candidates : eg. Candidate[1].voteCount
    mapping(uint => candidate) public Candidate; 
    // this public mapping will help us to get all detials of candidate just by giving id as input

    // event when voter votes for a candidate
    event vote(address indexed voter, uint indexed candidateID);

    // event to declare draw
    event isDraw(string statement1, uint d, string statement2);

    // event to declare one winner
    event whoIsWinner(uint indexed candidateID, string name);


    constructor(){
        owner = msg.sender;
        candidateCount = 3;
    }

    modifier onlyowner(address _addr){
        require(_addr == owner, "Only election commisson can add candidates");
        _;
    }

    function addCandidate(string memory _name) public onlyowner(msg.sender){
        ++candidateID;
        if(candidateID == 1){
            start = block.timestamp;
        }
        require(block.timestamp <= start + durationOfCandidateRegistration, "Registration period for new candidates has ended since voting has already begun");
        require(candidateID <= candidateCount, "Total candidates standing for election can't be greater than 3");
        Candidate[candidateID]= candidate(candidateID, _name, 0); //initial vote count is zero
    }

    function voteForCandidate(uint _id)public{
        require(block.timestamp <= (start + durationOfCandidateRegistration + durationOfElection)); // voting should be allowed within specific duration only
        require(votedOrNot[msg.sender] == false, "You have already cast your vote");
        require(_id <= candidateCount,"No such candidate exists, only three candidates are standing for election");
        require(Candidate[_id].id != 0, "Candidate with this id has not registered yet, so you can't cast vote for them");
        
        Candidate[_id].voteCount++;
        votedOrNot[msg.sender] = true;
        emit vote(msg.sender, _id);
    }

    function findWinner() public onlyowner(msg.sender) returns(string memory, uint) {

        require(block.timestamp >= (start + durationOfCandidateRegistration + durationOfElection), "Voting period hasn't ended! Wait for the final results");
        require(Candidate[1].voteCount>0 || Candidate[2].voteCount>0 || Candidate[3].voteCount>0, "No candidate has received any votes");
        uint maxVotes = 0 ;
        uint newMaxVotes;
        uint drawBetweenHowManyCandidates = 1;
        uint winner;
        for(uint8 i = 1 ; i <= 3 ; i++)
        {
            if(Candidate[i].voteCount >= maxVotes)
            {
                newMaxVotes = Candidate[i].voteCount;
                if (newMaxVotes == maxVotes){
                    drawBetweenHowManyCandidates++;
                }
                winner = i;
                maxVotes = newMaxVotes;
            }
        }
        if(drawBetweenHowManyCandidates > 1)
        {
            emit isDraw("There is draw between ", drawBetweenHowManyCandidates, " candidates");
            return ("There is draw between these no of candidates: ", drawBetweenHowManyCandidates);
        }
        else {
            emit whoIsWinner(winner, Candidate[winner].name);
            return (Candidate[winner].name, Candidate[winner].id);
        }


    }

}

