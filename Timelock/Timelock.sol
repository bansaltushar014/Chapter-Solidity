// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Timelock {
    enum txStage{ QUEUED, EXECUTED, EXPIRED }
    address targetAddress;
    uint minTime = 30; 
    uint txNumber = 0;
    struct queueData {
        string abiEncode;
        uint data;
        uint time;
        uint createdAt;
        txStage stage;
    }

    constructor(address _target){
        targetAddress = _target; 
    }

    mapping(uint => queueData) txRecord;
    queueData[] queueDataArray;

    event executx(string tx);

    function queueTx (string memory _abiEncode, uint _data, uint _time) public {
        queueData memory m1 = queueData({abiEncode: _abiEncode, data: _data, time: _time, createdAt: block.timestamp, stage: txStage(0)});
        queueDataArray.push(m1);
        txRecord[txNumber] = m1;
        txNumber++;
    }

    function getTx (uint _index) public view returns(uint, uint, txStage){
        queueData memory q1 = txRecord[_index];
        return (q1.data, q1.time, q1.stage);
    }

    function executeTx (uint _index) public {
        require(txRecord[_index].stage == txStage(0), "Cant Execute Anymore!");
        require(block.timestamp > minTime + txRecord[_index].createdAt, "tooEarly");
        if(block.timestamp > txRecord[_index].createdAt + txRecord[_index].time){
            txRecord[_index].stage = txStage(2);
        }
        (bool success, ) = targetAddress.call(abi.encodeWithSignature(txRecord[_index].abiEncode, txRecord[_index].data));
        require(success, "call failed");
        emit executx("Executed!");
    }  

}