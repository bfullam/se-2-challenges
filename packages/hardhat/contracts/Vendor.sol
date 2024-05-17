pragma solidity 0.8.4; //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
	event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
	event SellTokens(
		address seller,
		uint256 amountOfTokens,
		uint256 amountOfETH
	);

	YourToken public yourToken;
	uint256 public constant tokensPerEth = 100;

	constructor(address tokenAddress) {
		yourToken = YourToken(tokenAddress);
	}

	function buyTokens() public payable {
		uint256 amountOfTokens = msg.value * tokensPerEth;
		yourToken.transfer(msg.sender, amountOfTokens);
		emit BuyTokens(msg.sender, msg.value, amountOfTokens);
	}

	function withdraw() public onlyOwner {
		payable(owner()).transfer(address(this).balance);
	}

	function sellTokens(uint256 _amount) public {
		yourToken.transferFrom(msg.sender, address(this), _amount);
		payable(msg.sender).transfer(_amount / tokensPerEth);
		emit SellTokens(msg.sender, _amount, _amount / tokensPerEth);
	}
}
