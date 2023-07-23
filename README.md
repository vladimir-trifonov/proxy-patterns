# Practice

## The OZ upgrade tool for hardhat defends against 6 kinds of mistakes. What are they and why do they matter?

1. Checking for constructors in the implementation contract.
2. Check if the state variables are being set.
3. Change in variable order.
4. Insecure function calls such as delegatecall or selfdestruct.
5. Check for immutables.
6. Check for assembly usage.

## What is a beacon proxy used for?

A beacon proxy is used when we have multiple proxies referring to a single implementation contract which can be upgraded. If we use a Transparent proxy or UUPS Proxy you would have to upgrade the implementation contract address in all the proxies one by one.

## Why does the openzeppelin upgradeable tool insert something like `uint256[50] private __gap;` inside the contracts? To see it, create an upgradeable smart contract that has a parent contract and look in the parent

It is a placeholder that's added to upgradeable contracts to create room for future variables in the contract storage layout.

## What is the difference between initializing the proxy and initializing the implementation? Do you need to do both? When do they need to be done?

The proxy is initialized by constructor while the implementation is initialized by the `initialize` function. We need to do both. The proxy is initialized when it is deployed while the implementation after it is deployed.

## What is the use for the [reinitializer](https://github.com/OpenZeppelin/openzeppelin-contracts-upgradeable/blob/master/contracts/proxy/utils/Initializable.sol#L119)? Provide a minimal example of proper use in Solidity

A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
contract hasn't been initialized to a greater version before.
