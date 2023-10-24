// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import {MessagingStorage} from "./MessagingStorage.sol";
import {IZkSync} from "v2-testnet-contracts/l1/contracts/zksync/interfaces/IZkSync.sol";
import "v2-testnet-contracts/l2/system-contracts/Constants.sol";

contract ZkSyncMessaging is MessagingStorage {

    function zkSyncL1ToL2(bytes memory message, address routerAddr) internal {
        bytes memory _calldata = abi.encodeWithSignature("vMsgZkSyncL1ToL2(bytes)",message);

        IZkSync zksync = IZkSync(zkSyncAddress);

        // TODO Cause we don't charge any fee for now, but zkSync does, so we pay for them at this version.
        zksync.requestL2Transaction{value: zkSyncToL2Value}(
            routerAddr,
            zkSyncL2Value,
            _calldata,
            zkSyncL2GasLimit,
            zkSyncL2GasPerPubdataByteLimit,
            zkSyncFactoryDeps,
            zkSyncRefundRecipient
        );
    }

    function zkSyncL2ToL1(bytes memory message) internal returns(bytes32) {
        return L1_MESSENGER_CONTRACT.sendToL1(message);
    }
}