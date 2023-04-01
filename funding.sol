// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract FundingContract{
      address public creator;
      uint256 public goal;
      uint256 public deadline;
      mapping(address => uint256) public contributions;
      uint256 public totalContributions;
      bool public isFunded;
      bool public isCompleted;

      event GoalReached(uint256 totalContributions);
      event FundTransfer(address backer, uint256 amount);
      event DeadlineReached(uint256 totalContributions);

      constructor(uint256 fundingGoalInEther, uint256 durrationInMinutes) {
          creator = msg.sender;
          goal = fundingGoalInEther * 1 ether;
          deadline = block.timestamp + durrationInMinutes * 1 minutes;
          isFunded = false;
          isCompleted = false;
      }

      modifier onlyCreator() {
          require(creator == msg.sender, "Only creator can call this function");
          _;
      }

      function contribute() public payable {
          require(block.timestamp < deadline, "Funding period has been ended.");
          require(!isCompleted, "CrowdFunding is alredy completed");

          uint256 contribution = msg.value;
          contributions[msg.sender] += contribution;
          totalContributions += contribution;

          if(totalContributions >= goal){
              isFunded = true;
              emit GoalReached(totalContributions);
              
          }

          emit FundTransfer(msg.sender, contribution);
      }

      function WithdrawFunds() onlyCreator public{
          require(isFunded, "Goal has not been reached");
          require(!isCompleted, "CrowdFunding is alredy completed");

          isCompleted = true;

          payable(creator).transfer(address(this).balance);
      }
     
     function getCurrentBalance() public view returns(uint256){
         return address(this).balance;
     }

}