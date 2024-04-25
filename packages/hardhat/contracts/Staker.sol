
// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;  //Do not change the solidity version as it negativly impacts submission grading

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {
	ExampleExternalContract public exampleExternalContract;

	mapping(address => uint256) public balances;

	uint256 public constant threshold = 10 ether;

	uint256 public minimumDeposit = 1 ether;

	uint256 public deadline = block.timestamp + 30 seconds;

	event Stake(address from, uint256 amount);

	constructor(address exampleExternalContractAddress) {
		exampleExternalContract = ExampleExternalContract(
			exampleExternalContractAddress
		);
	}

	function stake() public payable {
		require(msg.value >= minimumDeposit, "Send enough ETH");
		require(
			msg.value + address(this).balance <= threshold,
			"ETH deposit must not exceed threshold!"
		);

		emit Stake(msg.sender, msg.value);
		balances[msg.sender] = msg.value;
	}

	function execute() public {
		require(
			address(this).balance == threshold,
			"Wait for deposit to get completed"
		);
		(bool success, ) = address(exampleExternalContract).call{
			value: address(this).balance
		}("");
		require(success, "Something went wrong!");

		exampleExternalContract.complete();
	}

	// Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
	// (Make sure to add a `Stake(address,uint256)` event and emit it for the frontend `All Stakings` tab to display)

	// After some `deadline` allow anyone to call an `execute()` function
	// If the deadline has passed and the threshold is met, it should call `exampleExternalContract.complete{value: address(this).balance}()`

	// If the `threshold` was not met, allow everyone to call a `withdraw()` function to withdraw their balance

	// Add a `timeLeft()` view function that returns the time left before the deadline for the frontendstall

	// Add the `receive()` special function that receives eth and calls stake()
}