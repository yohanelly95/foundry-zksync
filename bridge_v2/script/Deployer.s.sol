// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "../lib/forge-std/src/Script.sol";

import {stdJson} from "../lib/forge-std/src/StdJson.sol";
import "../src/ResultManager.sol";
import "../src/Forwarder.sol";
import "../src/TransparentForwarder.sol";
import "../src/Staking.sol";

contract Deployer is Script {
    using stdJson for string;
    address public SIGNER_ADDRESS = vm.envAddress("SIGNER_ADDRESS");
    bytes4 public RESULTGETTER_SELECTOR = 0xadd4c784;
    bytes4 public UPDATE_SELECTOR = 0x2d444fd5;
    bytes4 public VALIDATE_SELECTOR = 0x41417a9d;
    address public deployer;
    string internal _deployments;
    string internal _deploymentsPath;

    function run() public {
        deployer = vm.envAddress("DEPLOYER_ADDRESS");
        string memory network = vm.envString("NETWORK");
        _deploymentsPath = string.concat(
            string.concat("./deployments/", network),
            ".json"
        );

        vm.startBroadcast(deployer);

        // Deploy ResultManager
        ResultManager resultManager = new ResultManager(SIGNER_ADDRESS);
        _deployments.serialize("ResultManager", address(resultManager));
        // Deploy Forwarder
        Forwarder forwarder = new Forwarder(address(resultManager));
        _deployments.serialize("Forwarder", address(forwarder));
        // Deploy TransparentForwarder
        TransparentForwarder transparentForwarder = new TransparentForwarder(
            address(forwarder)
        );
        _deployments.serialize(
            "TransparentForwarder",
            address(transparentForwarder)
        );
        // Deploy Staking
        Staking staking = new Staking();
        _deployments = _deployments.serialize("Staking", address(staking));
        // Post Deployment
        // Grant FORWARDER_ROLE role to forwarder in resultManager
        ResultManager(resultManager).grantRole(
            ResultManager(resultManager).FORWARDER_ROLE(),
            address(forwarder)
        );

        // Grant TRANSPARENT_FORWARDER_ROLE role to transparentForwarder in forwarder
        Forwarder(forwarder).grantRole(
            Forwarder(forwarder).TRANSPARENT_FORWARDER_ROLE(),
            address(transparentForwarder)
        );

        // Grant FORWARDER_ADMIN_ROLE role to deployer in forwarder
        Forwarder(forwarder).grantRole(
            Forwarder(forwarder).FORWARDER_ADMIN_ROLE(),
            address(deployer)
        );

        // set resultGetterSelector in forwarder
        Forwarder(forwarder).setResultGetterSelector(RESULTGETTER_SELECTOR);

        // set updateSelector in forwarder
        Forwarder(forwarder).setUpdateSelector(UPDATE_SELECTOR);

        // set validateSelector in forwarder
        Forwarder(forwarder).setValidateSelector(VALIDATE_SELECTOR);

        // Grant TRANSPARENT_FORWARDER_ADMIN_ROLE role to admin in transparentForwarder
        TransparentForwarder(transparentForwarder).grantRole(
            TransparentForwarder(transparentForwarder)
                .TRANSPARENT_FORWARDER_ADMIN_ROLE(),
            address(deployer)
        );

        // Tranparent Forwarder setting staking address to Staking contract
        TransparentForwarder(transparentForwarder).setStaking(address(staking));

        // Grant TRANSPARENT_FORWARDER_ROLE role to transparentForwarder in staking
        Staking(staking).grantRole(
            Forwarder(forwarder).TRANSPARENT_FORWARDER_ROLE(),
            address(transparentForwarder)
        );

        _deployments.write(_deploymentsPath);

        vm.stopBroadcast();
    }
}
