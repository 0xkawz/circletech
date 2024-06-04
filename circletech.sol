/**
 *Submitted for verification at basescan.org on 2024-01-10
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract circletech {
    address public appFeeWallet; // Circle.tech fee address
    uint256 public appFeePercentage; // Circle.tech fee percentage
    uint256 public referralPercentage; // Referral percentage

    event Purchase(address indexed buyer, address indexed seller, uint256 amount, address indexed referral);
    event Chatroom(address indexed buyer, address indexed seller, uint256 amount, address indexed referral);

    constructor(address _appFeeWallet, uint256 _appFeePercentage, uint256 _referralPercentage) {
        appFeeWallet = _appFeeWallet;
        appFeePercentage = _appFeePercentage;
        referralPercentage = _referralPercentage;
    }

    modifier validPercentage(uint256 percentage) {
        require(percentage <= 100, "Percentage should be less than or equal to 100");
        _;
    }

    function setAppFeeWallet(address _newAppFeeWallet) external {
        require(msg.sender == appFeeWallet, "Only the app fee wallet can set a new wallet");
        appFeeWallet = _newAppFeeWallet;
    }

    function setAppFeePercentage(uint256 _newAppFeePercentage) external validPercentage(_newAppFeePercentage) {
        require(msg.sender == appFeeWallet, "Only the app fee wallet can set a new percentage");
        appFeePercentage = _newAppFeePercentage;
    }

    function setReferralFeePercentage(uint256 _newReferralPercentage) external validPercentage(_newReferralPercentage) {
        require(msg.sender == appFeeWallet, "Only the app fee wallet can set a new percentage");
        referralPercentage = _newReferralPercentage;
    }

    function askQuestion(address _seller, uint256 _purchaseAmount, address _referral) external payable {
        require(_purchaseAmount > 0, "Purchase amount must be greater than 0");
        require(msg.value == _purchaseAmount, "msg.value != _purchaseAmount");

        // Application fee
        uint256 appFee = (_purchaseAmount * appFeePercentage) / 100;

        // Referral take
        uint256 amountToReferrer = (_purchaseAmount * referralPercentage) / 100;

        // Seller take
        uint256 amountToSeller = _purchaseAmount - appFee - amountToReferrer;

        // Send to app fee wallet
        payable(appFeeWallet).transfer(appFee);

        // Send to referrer
        payable(_referral).transfer(amountToReferrer);

        // Send to seller
        payable(_seller).transfer(amountToSeller);

        // Emit purchase
        emit Purchase(msg.sender, _seller, _purchaseAmount, _referral);
    }

    function createChatroom(address _seller, uint256 _purchaseAmount, address _referral) external payable {
        require(_purchaseAmount > 0, "Purchase amount must be greater than 0");
        require(msg.value == _purchaseAmount, "msg.value != _purchaseAmount");

        // Application fee
        uint256 appFee = (_purchaseAmount * appFeePercentage) / 100;

        // Referral take
        uint256 amountToReferrer = (_purchaseAmount * referralPercentage) / 100;

        // Seller take
        uint256 amountToSeller = _purchaseAmount - appFee - amountToReferrer;

        // Send to app fee wallet
        payable(appFeeWallet).transfer(appFee);

        // Send to referrer
        payable(_referral).transfer(amountToReferrer);

        // Send to seller
        payable(_seller).transfer(amountToSeller);

        // Emit chatroom
        emit Chatroom(msg.sender, _seller, _purchaseAmount, _referral);
    }
}
