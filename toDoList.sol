// smart contract for ToDo list DApp made in BERN (Blockchain, Express.js, React.js, Node.js)

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ToDo{

    struct Task{
        uint id; //default = 0
        string name; // //default = ""
        string date; // date when the task needs to be done
    }

    address owner;
    Task task;
    mapping(uint=>Task) tasks; // list of all tasks
    uint taskId=1;

    modifier checkId(uint id){
        require(id!=0 && id<taskId, "Invalid ID is entered");
        _;
    }

    constructor(){
        owner = msg.sender;
    }

    // functions to perfrom CRUD on tasks
    function createTask(string calldata _taskName, string calldata _date)public{
        tasks[taskId] = Task(taskId, _taskName, _date);
        taskId++;
    }

    function updateTask(uint _taskId, string calldata _taskName, string calldata _date) checkId(_taskId)public{
        tasks[_taskId] = Task(taskId, _taskName, _date);
    }

    function viewTask(uint _taskId) checkId(_taskId) public view returns(Task memory){
        return tasks[_taskId];
    }
    // if mapping has list of all my tasks why do I need an array?
    // all mappings can't returned, they can be returned or accessed one at a time
    function allTask() public view returns(Task[] memory){
        Task[] memory taskList = new Task[](taskId-1);
        for(uint i=0;i<taskId-1;i++){
            taskList[i]=tasks[i+1];
        }
        return taskList;
    }

    // deletion isn't possible on blockchain, so this delete function changes all values in Task struct to default
    function deleteTask(uint _taskId) checkId(_taskId)public{
        delete tasks[_taskId];
    }

}

// smart contract address : 0x2921a0e10ebcbe03d9a07291f680b3dfa3bf20df
// deployed using sepolia testnet
// my metamask account used for deployment: learning soldity
// block explorer : https://sepolia.etherscan.io/tx/0x4b19c9991f20e854d4ec0a146e667ad0755cbef257ebb6e42439dc6508277b47
