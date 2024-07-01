import { expect } from "chai";
import hre from "hardhat";

describe("MerkleTree", function () {
  let merkleTree: any;
  let transactions: Array<String> = [
    "TX1: 1.1.2023 Test_Data_1",
    "TX2: 1.2.2023 Test_Data_2",
    "TX3: 1.3.2023 Test._Data_3",
    "TX4: 1.4.2023 Test_Data_4",
  ];

  before(async function () {
    const MerkleTree = await hre.ethers.getContractFactory("MerkleTree");
    merkleTree = await MerkleTree.deploy();
  });

  it("should return array", async function () {
    // Get the transactions array
    const transactions = await Promise.all([
      merkleTree.transactions(0),
      merkleTree.transactions(1),
      merkleTree.transactions(2),
      merkleTree.transactions(3),
    ]);

    // Check if the transactions array is as expected
    expect(transactions).to.deep.equal([
      "TX1: 1.1.2023 Test_Data_1",
      "TX2: 1.2.2023 Test_Data_2",
      "TX3: 1.3.2023 Test._Data_3",
      "TX4: 1.4.2023 Test_Data_4",
    ]);
  });

  it("should validate the transactions", async function () {
    // Assert that the value is correct
    const tx2 = "TX2: 1.2.2023 Test_Data_2";
    const tx3 = "TX3: 1.3.2023 Test._Data_3";
    let index = 1;

    let isValid = await merkleTree.validateTransaction(tx2, index);
    expect(isValid).to.be.true;

    index = 2;
    isValid = await merkleTree.validateTransaction(tx3, index);
  });

  it("should not validate an incorrect transaction/index", async function () {
    // Assert that the value is correct
    const tx = "TX3: 1.3.2023 Test._Data_3";
    let index = 3;

    let isValid = await merkleTree.validateTransaction(tx, index);
    expect(isValid).to.be.false;
  });
});
