        // SPDX-License-Identifier: MIT
        pragma solidity ^0.8.0;


import './ERC165.sol';
import './interfaces/IERC721.sol';

        contract ERC721 is ERC165, IERC721 {
            /*BUILDING THE MINTING FUNCTION
            a. nft to have address.
            b. keep track of nft id
            c. keep track of who has which nft(addresses and token ids)
            d. keep track of how many tokens an owner address has
            e. create event that builds transfer log, the minted and ids

            */


            //Mapping from token id to owner
            mapping(uint256 => address) private _tokenOwner;

            //mapping from owner to no. of owned tokens
            mapping(address => uint256) private _OwnedTokensCount;

            //mapping from token id to approved addresses
            mapping(uint256 => uint256) private _tokenApprovals;


            

             constructor() {
        _registerInterface(bytes4(keccak256('balanceOf(bytes4)')^
        keccak256('ownerOf(bytes4)')^keccak256('transferFrom(bytes4)')));

    }



            function balanceOf(address _owner) public override view returns(uint256) {
               require(_owner != address(0), 'owner query for non-existent token');
                return _OwnedTokensCount[_owner];
            }

            function ownerOf(uint256 _tokenId) public override view returns (address) {
                address owner = _tokenOwner[_tokenId];
                 require(owner != address(0), 'owner query for non-existent token');
                return owner;
            }

            function _exists(uint256 tokenId ) internal view returns(bool){
                //set address to check the address of tokenOwnerat tokenId
                address owner = _tokenOwner[tokenId];
                //return truthfulness of the address is not zero
                return owner != address(0);
            }

            function _mint(address to, uint256 tokenId) internal virtual {

    //requires address isnt zero
                require(to != address(0), 'ERROR - Minting to zero address');
                //require token dosnt exist already
                require(!_exists(tokenId), 'ERC721: TOKEN ALREADY EXISTS');
                //we are adding new address with token id for minting
                _tokenOwner[tokenId] = to;
                //keeping track of minting and adding one
                _OwnedTokensCount[to] += 1;

                emit Transfer(address(0), to, tokenId);
            }

            function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
                require(_to != address(0), 'Error - ERC721 Transfer to the zero address');
                require(ownerOf(_tokenId) == _from, 'Trying to transfer a token the address does not own!');

                _OwnedTokensCount[_from] -= 1;
                _OwnedTokensCount[_to] += 1;

                _tokenOwner[_tokenId] = _to;

                emit Transfer(_from, _to, _tokenId);
            }

            function transferFrom(address _from,address  _to,uint256  _tokenId)  override public{
                _transferFrom(_from, _to, _tokenId);


            }
    //OPTIONAL
           /* function approve(address _to, uint256 tokenId) public {
                address owner = ownerOf(tokenId);
                require(_to != owner, 'Error - approval to current owner');
                require(msg.sender == owner, 'Current caller is not owner');
                _tokenApprovals[tokenId] = _to;
            } 
            */


        }