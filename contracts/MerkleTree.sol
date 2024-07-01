pragma solidity ^0.8.24;

contract MerkleTree {
    string[4] public transactions = [
        "TX1: 1.1.2023 Test_Data_1",
        "TX2: 1.2.2023 Test_Data_2",
        "TX3: 1.3.2023 Test._Data_3",
        "TX4: 1.4.2023 Test_Data_4"
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
                            hashes[shift + i],
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
    ) public view returns (bool) {
        // Marked as view
        bytes32 hash = keccak256(abi.encodePacked(transaction));

        uint counter = transactions.length;
        uint shift = 0;

        while (counter > 1) {
            uint siblingIndex;
            if (index % 2 == 0) {
                siblingIndex = index + 1;
            } else {
                siblingIndex = index - 1;
            }

            if (siblingIndex < counter) {
                if (index % 2 == 0) {
                    hash = keccak256(
                        abi.encodePacked(hash, hashes[shift + siblingIndex])
                    );
                } else {
                    hash = keccak256(
                        abi.encodePacked(hashes[shift + siblingIndex], hash)
                    );
                }
            }

            index = index / 2;
            shift += counter;
            counter = counter / 2;
        }

        return hash == hashes[hashes.length - 1];
    }
}
