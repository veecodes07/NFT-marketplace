        // SPDX-License-Identifier: MIT
        pragma solidity ^0.8.0;

import './ERC721.sol';
import './interfaces/IERC721Enumerable.sol'; 


    contract ERC721Enumerable is IERC721Enumerable, ERC721 {

    uint256[] private _allTokens;

    //mapping from tokenId to position in _allTokens
    mapping(uint256 => uint256) private _allTokensIndex;

    //mapping of owner to list of all owner ids
    mapping(address => uint256[]) private _ownedTokens;

    //mapping from token Id index of owner tokens list
    mapping(uint256 => uint256) private _ownedTokensIndex;

   
             constructor() {
        _registerInterface(bytes4(keccak256('totalSupply(bytes4)')^
        keccak256('tokenByIndex(bytes4)')^keccak256('tokenOfOwnerByIndex(bytes4)')));

    }


    function _mint(address to, uint256 tokenId) internal override(ERC721) {
        super._mint(to, tokenId);
        _addTokensToAllTokenEnumeration(tokenId);
        _addTokensToOwnerEnumeration(to, tokenId);
    }

    //ADD TOKENS TO THE OWNER
    function _addTokensToAllTokenEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    //returns tokenIndex
    function tokenByIndex(uint256 index) public view override returns(uint256) {
       require(index < totalSupply(), 'global index is out of bounds!');
        return _allTokens[index];
        
    }

    //returns tokenOf OwnerByIndex
    function tokenOfOwnerByIndex(address owner, uint index) public view override returns(uint256) {
       require(index < balanceOf(owner), 'owner index is out of bounds!');
        return _ownedTokens[owner][index];
    }

    function _addTokensToOwnerEnumeration(address to, uint256 tokenId) private {
       _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
       _ownedTokens[to].push(tokenId); 
    }

//return the total supply of all tokens array.
    function totalSupply()public view override returns(uint256) {
        return _allTokens.length;
    }









    }