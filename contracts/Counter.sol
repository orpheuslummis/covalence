// SPDX-License-Identifier: BSD-3-Clause-Clear

pragma solidity >=0.8.13 <0.9.0;

import "fhevm/lib/TFHE.sol";

contract Counter {
    euint32 private counter;

    function add(bytes calldata encryptedValue) public {
        euint32 value = TFHE.asEuint32(encryptedValue);
        counter = TFHE.add(counter, value);
    }

    function getCounter(bytes32 publicKey) public view returns (bytes memory) {
        return TFHE.reencrypt(counter, publicKey);
    }
}
