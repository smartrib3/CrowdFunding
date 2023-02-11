// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
 
contract CrowdFunding {
    mapping(address => uint) public contributors;
    address public admin;
    uint public noOfContributors;
    uint public minimumContribution;
    uint public deadline; //timestamp
    uint public goal;
    uint public raisedAmount;
    
  
    // Spending Request
    struct Request {
        string description;
        address payable recipient;
        uint value;
        bool completed;
        uint noOfVoters;
        mapping(address => bool) voters;
    }
    
    // mapping of spending requests
    // the key is the spending request number (index) - starts from zero
    // the value is a Request struct
    mapping(uint => Request) public requests;
    uint public numRequests;
    
    // events to emit
    event ContributeEvent(address _sender, uint _value);
    event CreateRequestEvent(string _description, address _recipient, uint _value);
    event MakePaymentEvent(address _recipient, uint _value);
    
    
    constructor(uint _goal, uint _deadline) {
        goal = _goal;
        deadline = block.timestamp + _deadline;
        admin = msg.sender;
        minimumContribution = 100 wei;
    }
    
   
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can execute this");
        _;
    }
    
    
    function contribute() public payable {
        require(block.timestamp < deadline, "The Deadline has passed!");
        require(msg.value >= minimumContribution, "The Minimum Contribution not met!");
        
        // incrementing the no. of contributors the first time when 
        // someone sends eth to the contract
        if(contributors[msg.sender] == 0) {
            noOfContributors++;
        }
        
        contributors[msg.sender] += msg.value;
        raisedAmount += msg.value;
        
        emit ContributeEvent(msg.sender, msg.value);
    }
    

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
    
    // function to allow contributors to get a refund if the goal was not met within the deadline
function getRefund() public {
    // Check if the deadline has passed
    require(block.timestamp > deadline, "Deadline has not passed.");
    // Check if the goal was not met
    require(raisedAmount < goal, "The goal was met");
    // Check if the msg.sender has contributed to the crowdfunding
    require(contributors[msg.sender] > 0, "You have not contributed to the crowdfunding.");

    // Set the recipient as the contributor
    address payable recipient = payable(msg.sender);
    // Get the value the contributor has contributed
    uint value = contributors[msg.sender];

    // Reset the contribution of the contributor
    contributors[msg.sender] = 0;
    // Transfer the contribution to the contributor's address
    recipient.transfer(value);
}
    
    
    function createRequest(string calldata _description, address payable _recipient, uint _value) public onlyAdmin {
        //numRequests starts from zero
        Request storage newRequest = requests[numRequests];
        numRequests++;
        
        newRequest.description = _description;
        newRequest.recipient = _recipient;
        newRequest.value = _value;
        newRequest.completed = false;
        newRequest.noOfVoters = 0;
        
        emit CreateRequestEvent(_description, _recipient, _value);
    }
    
    
    function voteRequest(uint _requestNo) public {
        require(contributors[msg.sender] > 0, "You must be a contributor to vote!");
        
        Request storage thisRequest = requests[_requestNo];
        require(thisRequest.voters[msg.sender] == false, "You have already voted!");
        
        thisRequest.voters[msg.sender] = true;
        thisRequest.noOfVoters++;
    }
    
    
    function makePayment(uint _requestNo) public onlyAdmin {
        Request storage thisRequest = requests[_requestNo];
        require(thisRequest.completed == false, "The request has been already completed!");
        
        require(thisRequest.noOfVoters > noOfContributors / 2, "The request needs more than 50% of the contributors.");
        
        // setting thisRequest as being completed and transfering the money
        thisRequest.completed = true;
        thisRequest.recipient.transfer(thisRequest.value);
        
        emit MakePaymentEvent(thisRequest.recipient, thisRequest.value);
    }
    
}
