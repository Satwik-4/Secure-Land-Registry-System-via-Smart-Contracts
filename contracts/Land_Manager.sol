//* SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//* Import necessary Solidity libraries and contracts
//*import "@openzeppelin/contracts/token/ERC721/ERC721.sol"; (commented out)
import "@openzeppelin/contracts/token/ERC721/IERC721.sol"; //* Import ERC721 interface
import "@openzeppelin/contracts/access/Ownable.sol"; //* Ownable contract for ownership control

//* Define a new contract called Land_Manager that inherits from Ownable
contract Land_Manager is Ownable {

    //* Define a struct to store details of land sales
    struct landSaleDetails {
        address _address;
        uint256 _Id;
        uint256 _price;
    }

    //* Mapping to associate land token IDs with sale details
    mapping (address => mapping(uint256 => landSaleDetails)) public IdToDetails;

    //* Array to store all land sales
    landSaleDetails[] public landsForSale;

    //* Function to list land for sale
    function list(address _address, uint256 _Id, uint256 _price) public payable {
        //* Check if the sender is the owner of the specified land token
        require(msg.sender == IERC721(_address).ownerOf(_Id), "You are not the owner!!!!");

        //* Store sale details in mapping
        IdToDetails[_address][_Id] = landSaleDetails(
            _address,
            _Id,
            _price
        );

        //* Create a sale struct and add it to the landsForSale array
        landSaleDetails memory sale = landSaleDetails({
            _address: _address,
            _Id: _Id,
            _price: _price
        });
        landsForSale.push(sale);
    }

    //* Function to delist land from sale
    function delist(address _address, uint256 _Id) public payable {
        //* Check if the sender is the owner of the specified land token
        require(msg.sender == IERC721(_address).ownerOf(_Id), "You are not the owner!!!!");

        //* Remove sale details from the mapping
        delete IdToDetails[_address][_Id];

        //* Find and remove the sale from the landsForSale array
        for (uint256 i = landsForSale.length - 1; i >= 0; i--) {
            if (landsForSale[i]._address == _address && landsForSale[i]._Id == _Id) {
                landsForSale[i] = landsForSale[landsForSale.length - 1];
                landsForSale.pop();
                break;
            }
        }
    }

    //* Function to buy land that is listed for sale
    function buy(address _address, uint256 _Id) public payable {
        //* Get the current owner of the land
        address owner = IERC721(_address).ownerOf(_Id);

        //* Check if the sent value is greater than or equal to the land's sale price
        require(msg.value >= IdToDetails[_address][_Id]._price * 1 gwei, "More Please!!!!");

        //* Transfer ownership of the land to the buyer
        IERC721(_address).transferFrom(owner, msg.sender, _Id);

        //* Calculate the amount to be sent to the seller after a fee (160,000 / 1,000,000)
        (bool sent, ) = (owner).call{value: (IdToDetails[_address][_Id]._price - (160000 * IdToDetails[_address][_Id]._price/1000000)) * 1 gwei}("");
        require(sent, "Failed to send Ether");

        //* Remove sale details from the mapping
        delete IdToDetails[_address][_Id];

        //* Find and remove the sale from the landsForSale array
        for (uint256 i = landsForSale.length - 1; i >= 0; i--) {
            if (landsForSale[i]._address == _address && landsForSale[i]._Id == _Id) {
                landsForSale[i] = landsForSale[landsForSale.length - 1];
                landsForSale.pop();
                break;
            }
        }
    }

    //* Function to get the list of land sales
    function getlandsForSale() public view returns (landSaleDetails[] memory) {
        return landsForSale;
    }
}
