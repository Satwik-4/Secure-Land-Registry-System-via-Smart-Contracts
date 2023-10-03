//* SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//* Import necessary Solidity libraries and contracts
import "@openzeppelin/contracts/token/ERC721/ERC721.sol"; //* ERC721 token implementation
import "@openzeppelin/contracts/access/Ownable.sol"; //* Ownable contract for ownership control

//* Define a new contract called Land_Registry that inherits from ERC721 and Ownable
contract Land_Registry is ERC721, Ownable {
    
    using Strings for uint256; //* Import a library for handling strings
    
    uint256 public tokenCounter; //* Public variable to keep track of the token count
    
    //* Mapping to store token URIs associated with token IDs
    mapping (uint256 => string) private _tokenURIs;
    
    //* Mapping to store addresses of admins (who have special permissions)
    mapping(address => bool) public _admins;

    //* Constructor function to initialize the contract
    constructor() ERC721("HYDERABAD", "HYD") {
        tokenCounter = 0; //* Initialize the token counter to 0
        _admins[msg.sender] == true; //* Mark the deployer of the contract as an admin
    }

    //* Function to set approval status for an operator (only callable by the owner)
    function setApproval(address operator, bool approved) public onlyOwner {
        _setApproval(operator, approved);
    }

    //* Internal function to set approval status for an operator
    function _setApproval(
        address operator,
        bool approved
    ) internal virtual {
        _admins[operator] = approved; //* Set approval status for the operator
        //*emit ApprovalForAll(owner, operator, approved); //* Emit an event (commented out)
    }

    //* Function to set the base URI for token metadata (only callable by the owner)
    function setBaseURI(string memory baseURI) public virtual onlyOwner {
        _setBaseURI(baseURI);
    }

    //* Function to set the token URI for a specific token ID
    function setTokenURI(uint256 tokenId, string memory _tokenURI) public {
        //*require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not owner no approved"); //* Check if the caller is the owner or approved (commented out)
        require(_admins[msg.sender] == true); //* Check if the caller is an admin
        _setTokenURI(tokenId, _tokenURI); //* Set the token URI
        tokenURI(tokenId); //* Return the token URI
    }

    //* Internal function to set the token URI for a specific token ID
    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token"); //* Check if the token exists
        _tokenURIs[tokenId] = _tokenURI; //* Set the token URI
    }

    //* Function to get the token URI for a specific token ID
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token"); //* Check if the token exists

        string memory _tokenURI = _tokenURIs[tokenId]; //* Get the token URI
        string memory base = baseURI(); //* Get the base URI

        //* If there is no base URI, return the token URI.
        if (bytes(base).length == 0) {
            return _tokenURI;
        }
        //* If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }
        //* If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
        return string(abi.encodePacked(base, tokenId.toString()));
    }

    //* Function to transfer a token from one address to another (only callable by admins)
    function transferFrom(address from, address to, uint256 tokenId) public virtual override {
        //*solhint-disable-next-line max-line-length
        //*require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved"); //* Check if the caller is the owner or approved (commented out)
        require(_admins[msg.sender] == true); //* Check if the caller is an admin

        _transfer(from, to, tokenId); //* Transfer the token
    }

    //* Function to safely transfer a token from one address to another (only callable by admins)
    function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }

    //* Function to safely transfer a token from one address to another with data (only callable by admins)
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
        //*require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved"); //* Check if the caller is the owner or approved (commented out)

        require(_admins[msg.sender] == true); //* Check if the caller is an admin
        _safeTransfer(from, to, tokenId, _data); //* Safely transfer the token with data
    }

    //* Function to mint a new token and set its metadata URI (only callable by admins)
    function mint(address _address, uint256 _tokenId, string memory _tokenURI) public {
        //* Check if the caller is an admin
        require(_admins[msg.sender] == true); 

        //* Mint a new token with the given token ID and assign it to the specified address
        _mint(_address, _tokenId); 

        //* Set the metadata URI for the newly minted token
        _setTokenURI(_tokenId, _tokenURI);

        //* Increment the token counter to reflect the newly minted token
        tokenCounter++; 
    }

}
