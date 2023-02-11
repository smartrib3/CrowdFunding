# Crowdfunding Contract

This contract is a modified version of the original contract developed in an online Udemy course. The original contract was used to demonstrate how to create a crowdfunding platform using Solidity.

## Changes Made

The original contract had a problem with the getRefund function, where a contributor could not get a refund if the goal was not met within the deadline. This has been fixed in this version of the contract.

## Functions

The contract has the following functions:

- `contribute`: allows a contributor to contribute to the crowdfunding campaign by sending ETH to the contract.
- `getRefund`: allows a contributor to get a refund if the goal was not met within the deadline.
- `createRequest`: allows the admin to create a spending request.
- `voteRequest`: allows contributors to vote on a spending request.
- `makePayment`: allows the admin to make a payment on a spending request that has received more than 50% of the votes from the contributors.
- `getBalance`: returns the balance of the contract.

## Events

The contract has the following events:

- `ContributeEvent`: emitted when a contributor contributes to the crowdfunding campaign.
- `CreateRequestEvent`: emitted when the admin creates a spending request.
- `MakePaymentEvent`: emitted when the admin makes a payment on a spending request.
