// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "./interface/IStaking.sol";

contract TransparentForwarder is AccessControlEnumerable {
    bytes32 public constant TRANSPARENT_FORWARDER_ADMIN_ROLE =
        keccak256("TRANSPARENT_FORWARDER_ADMIN_ROLE");
    address public forwarder;
    IStaking public staking;

    error ZeroAddress();

    constructor(address _forwarder) {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        if (_forwarder == address(0)) revert ZeroAddress();
        forwarder = _forwarder;
    }

    // solhint-disable
    fallback() external payable {
        bool isWhitelisted = staking.isWhitelisted{value: msg.value}(
            msg.sender
        );
        require(isWhitelisted, "Not whitelisted");

        address forwarderContract = forwarder;
        // slither disabled b/c we want to use low-level calls
        // slither-disable-next-line assembly
        assembly {
            // Copy msg.data. We take full control of memory in this inline assembly
            // block because it will not return to Solidity code. We overwrite the
            // Solidity scratch pad at memory position 0.

            // calldatacopy(t, f, s) - copy s bytes from calldata at position f to mem at position t
            // calldatasize() - size of call data in bytes
            calldatacopy(0, 0, calldatasize())

            // Call the implementation.
            // out and outsize are 0 because we don't know the size yet.

            // call(g, a, in, insize, out, outsize) -
            // - call contract at address a
            // - with input mem[in…(in+insize))
            // - providing g gas
            // - and output area mem[out…(out+outsize))
            // - returning 0 on error (eg. out of gas) and 1 on success
            let result := call(
                gas(),
                forwarderContract,
                0,
                0,
                calldatasize(),
                0,
                0
            )

            // Copy the returned data.
            // returndatacopy(t, f, s) - copy s bytes from returndata at position f to mem at position t
            // returndatasize() - size of the last returndata
            returndatacopy(0, 0, returndatasize())

            switch result
            // delegatecall returns 0 on error.
            case 0 {
                // revert(p, s) - end execution, revert state changes, return data mem[p…(p+s))
                revert(0, returndatasize())
            }
            default {
                // return(p, s) - end execution, return data mem[p…(p+s))
                return(0, returndatasize())
            }
        }
    }
    // solhint-enable

    function setForwarder(
        address _forwarder
    ) external onlyRole(TRANSPARENT_FORWARDER_ADMIN_ROLE) {
        if (_forwarder == address(0)) revert ZeroAddress();
        forwarder = _forwarder;
    }

    function setStaking(
        address _staking
    ) external onlyRole(TRANSPARENT_FORWARDER_ADMIN_ROLE) {
        if (_staking == address(0)) revert ZeroAddress();
        staking = IStaking(_staking);
    }
}
