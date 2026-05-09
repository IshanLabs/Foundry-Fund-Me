// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

error NotOwner();

contract FundMe{
    uint256 public constant MINIMUM_ETH = 0.001 ether;
    address public immutable i_owner;
    mapping (address => uint256) public AddressToAmtFunded;
    address[] public funders;

    constructor(){
       i_owner = msg.sender;
    }
    function fund() public payable{
        require(msg.value >= MINIMUM_ETH,"Min. Ether is 0.001");
        AddressToAmtFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }
    function withdraw() public{
        if(msg.sender != i_owner){
            revert NotOwner();
        }
        
        for (uint256 i = 0; i < funders.length; i++) {
            address funder = funders[i];
            AddressToAmtFunded[funder] = 0;
        }

        funders = new address[](0);

        (bool sent, ) = payable(i_owner).call{
            value: address(this).balance
        }("");
        require(sent,"Transaction Failed!");
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
    receive() external payable {}
    
}