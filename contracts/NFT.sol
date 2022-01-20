//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./ERC721.sol";
import "./Ownable.sol";
import "./interface/Counters.sol";

contract NFT is ERC721, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint256;
    string public baseExtension = ".json";
    string public baseURI;
    string _initBaseURI = "https://metadata.x-protocol.com/xma/";
    uint256 public constant total = 30;
    Counters.Counter private currentTokenId;
    mapping(uint256 => string) private _tokenURIs;

    constructor() ERC721("X-Metaverse Avatar", "XMA") {
        setBaseURI(_initBaseURI);
        for (uint256 i = 0; i < 30; i++) {
            _mint(msg.sender);
        }
    }

    function _mint(address recipient) internal onlyOwner returns (uint256) {
        currentTokenId.increment();
        require(total >= currentTokenId._value, "Exceed the levy limit");
        uint256 newItemId = currentTokenId.current();
        _safeMint(recipient, newItemId);
        return newItemId;
    }

    function lock(uint256 tokenId) public {
        require(_checkNftOwner(tokenId), "Not Nft Owner");
        nftLock[tokenId] = true;
    }

    function unlock(uint256 tokenId) public {
        require(_checkNftOwner(tokenId), "Not Nft Owner");
        nftLock[tokenId] = false;
    }

    function _checkNftOwner(uint256 tokenId) internal view returns (bool) {
        address owner = ERC721.ownerOf(tokenId);
        return owner == msg.sender;
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent NFT"
        );

        string memory currentBaseURI = _baseURI();
        return
            bytes(currentBaseURI).length > 0
                ? string(
                    abi.encodePacked(
                        currentBaseURI,
                        tokenId.toString(),
                        baseExtension
                    )
                )
                : "";
    }
}
