// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./BaseActiveMembersBadge.sol";
import "../interfaces/IMintableERC721.sol";

contract RootActiveMembersBadge is BaseActiveMembersBadge, IMintableERC721 {
    // Stuff needed for Polygon mintable assets
    bytes32 public constant PREDICATE_ROLE = keccak256("PREDICATE_ROLE");

    // END

    constructor(string memory _imageCID, string memory _animationCID)
        BaseActiveMembersBadge(_imageCID, _animationCID)
    {
        _grantRole(PREDICATE_ROLE, _msgSender());
    }

    /**
     * @dev See {IMintableERC721-mint}.
     */
    function mint(address user, uint256 tokenId)
        external
        override
        onlyRole(PREDICATE_ROLE)
    {
        _safeMint(user, tokenId);
        // let's directly delegate the vote to the minter for convenience
        delegate(_msgSender());
    }

    /**
     * @dev See {IMintableERC721-mint}.
     *
     * If you're attempting to bring metadata associated with token
     * from L2 to L1, you must implement this method
     */
    function mint(
        address user,
        uint256 tokenId,
        bytes calldata metaData
    ) external override onlyRole(PREDICATE_ROLE) {
        (metaData); // to avoid linting error
        _safeMint(user, tokenId);
        // the metadata gets generated by the contract so we don't need to do anything here.
        // we just keep this function for compatability
        // setTokenMetadata(tokenId, metaData);

        // let's directly delegate the vote to the minter for convenience
        delegate(_msgSender());
    }

    // we don't need this function! (see above)
    /*
     * If you're attempting to bring metadata associated with token
     * from L2 to L1, you must implement this method, to be invoked
     * when minting token back on L1, during exit
     */
    // function setTokenMetadata(uint256 tokenId, bytes memory data)
    //     internal
    //     virtual
    // {
    //     // This function should decode metadata obtained from L2
    //     // and attempt to set it for this `tokenId`
    //     //
    //     // Following is just a default implementation, feel
    //     // free to define your own encoding/ decoding scheme
    //     // for L2 -> L1 token metadata transfer
    //     string memory uri = abi.decode(data, (string));

    //     _setTokenURI(tokenId, uri);
    // }

    /**
     * @dev See {IMintableERC721-exists}.
     */
    function exists(uint256 tokenId) external view override returns (bool) {
        return _exists(tokenId);
    }
}
