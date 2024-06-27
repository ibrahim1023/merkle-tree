// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

contract MerkleTree {
    string[4] public transactions = [
        "TX1: 1.1.2023 Test_Data_1",
        // 0x60e4914c4d09b3a2b8a1c49802650b08cdd4c3869617c68f59694f87e786b4f8
        "TX2: 1.2.2023 Test_Data_2",
        // 0x5f627727229123bcf626da344dac895418f2fdd6090158870d7a669e1321e0a2
        "TX3: 1.3.2023 Test._Data_3",
        // Oxdad1a19dac9c857f64610acd5d9663198722135586d47ef6183838fd7a76b0e9
        "TX4: 1.4.2023 Test_Data_4"
        // 0xd213e9a093c1f9a094adb8e54bc2828d4a8135b58e5746d4a646aed7b830b9c0
    ];

    bytes32[] public hashes;

    constructor() {
        for (uint i = 0; i < transactions.length; i++) {
            hashes.push(keccak256(abi.encodePacked(transactions[i])));
        }

        uint shift = 0;
        uint counter = transactions.length;

        while (counter > 0) {
            for (uint i = 0; i < counter - 1; i += 2) {
                hashes.push(
                    keccak256(
                        abi.encodePacked(
                            hashes[shift + 1],
                            hashes[shift + i + 1]
                        )
                    )
                );
            }

            shift += counter;
            counter /= 2;
        }
    }

    function validateTransaction(
        string memory transaction,
        uint index
    ) public returns (bool) {
        bytes32 hash = keccak256(abi.encodePacked(transaction));

        uint counter = 1;
        uint transactionsLength = transactions.length;

        while (transactionsLength != 2) {
            counter++;
            transactionsLength /= 2;
        }

        uint[] memory proofsIndexes = new uint[](counter);
        uint proofIndex = index;

        for (uint i = 0; i < proofsIndexes.length; i++) {
            if (proofIndex % 2 == 0) {
                proofsIndexes[i] = proofIndex + 1;
            } else {
                proofsIndexes[i] = proofIndex - 1;
            }

            proofIndex = transactions.length + uint(proofIndex) / 2;
        }

        for (uint i = 0; i < proofsIndexes.length; i++) {
            if (index % 2 == 0) {
                hash = keccak256(
                    abi.encodePacked(hash, hashes[proofsIndexes[i]])
                );
            } else {
                hash = keccak256(
                    abi.encodePacked(hashes[proofsIndexes[i]], hash)
                );
            }

            index /= 2;
        }

        return hash == hashes[hashes.length - 1];
    }
}
