// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {Pokemon} from "../src/example/Pokemon.sol";
import "forge-std/Script.sol";
import {Merkle} from "murky/src/Merkle.sol";

contract DeployScript is Script {
    //Pokemon pk;
    Pokemon pk;
    Merkle allowlistMerkle;

    bytes32 allowlistRoot;
    bytes32[] allowlistData = new bytes32[](2);

    uint96 publicPrice = 151000 ether;
    uint96 allowlistPrice = 1 ether;

    uint256 private constant _WAD = 10 ** 18;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        address owner = address(0x5ae6D566299538ef9B538dceA3F2CD7512C3E5dc); //prof oak

        string memory baseURI =
            "https://jade-improved-barracuda-470.mypinata.cloud/ipfs/QmcDWNPNuscUAW1vWMhZtYtyuNcJ4P84RbeTbVitKZaDcG";

        allowlistMerkle = new Merkle();
        allowlistData[0] = bytes32(keccak256(abi.encodePacked(owner)));
        allowlistRoot = allowlistMerkle.getRoot(allowlistData);

        pk = new Pokemon(
            "Pocket Monsters",
            "POK\u00C9",
            allowlistRoot,
            publicPrice,
            allowlistPrice,
            uint96(15100000 * _WAD),
            address(owner)
        );
        pk.toggleLive();

        if (!pk.transfer(address(0x30BD77A70F2F88505cd389Ed0C326F3E127dC6ef), 15100000 * _WAD)) {
            //gary
            revert("Transfer failed");
        }

        pk.setBaseURI(baseURI);

        vm.stopBroadcast();
    }
}
