// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";


contract MerkleAirdrop {

    IERC20 public token;
    bytes32 public merkleRoot;
    mapping(address => bool) public tokenClaimed;
    mapping(address => mapping(uint256 => bool)) public addressClaims;
    bytes32 public root =  0x87ae53e2b2469c1920a68f15b379ca9ff04ae072d4992f627bc1f40b6966458c;

    struct AddressAirdrop {
        string name;
        uint256 airdropID;
        uint256 claims;
    }
    mapping(uint256 => AddressAirdrop) public addressAirdrops;
    event AddressClaim(uint256 airdropID, address account, uint256 itemId, uint256 amount);
    constructor(address _tokenAddr, bytes32 _merkleRoot){
        token = IERC20(_tokenAddr);
        merkleRoot = _merkleRoot;
    }

    modifier notClaimed(){
        require(tokenClaimed[msg.sender] == false, "already claimed");
        _;
    }

    function claimForAddress(uint256 _airdropId, uint256 _itemId, uint256 _amount, bytes32[] calldata _merkleProof
    ) external notClaimed() {
        AddressAirdrop storage drop = addressAirdrops[_airdropId];
        // Verify the merkle proof.
        bytes32 node = keccak256(abi.encodePacked(msg.sender, _itemId, _amount));
        require(MerkleProof.verify(_merkleProof, root, node), "MerkleDistributor: Invalid proof.");
        // Mark it claimed and send the token.
        setAddressClaimed(msg.sender, _airdropId);
        IERC20(token).transfer(msg.sender, _amount);
        drop.claims++;
        //only emit when successful
        emit AddressClaim(_airdropId, msg.sender, _itemId, _amount);
    }

    function setAddressClaimed(address _user, uint256 _airdropID) private {
        addressClaims[_user][_airdropID] = true;
    }
}