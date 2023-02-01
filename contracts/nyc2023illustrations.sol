// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";

contract W23NYC is ERC1155, Ownable, ERC1155Burnable {
    string public constant name = "Thank You Gift for New Year Card Illusturations";
    string public constant symbol = "W23NYCTHANKYOU";

    address[] mintErrorAddresses;
    error MintError(address[] to);

    constructor() ERC1155("https://raw.githubusercontent.com/wagumi/nyc2023-illustrations/main/assets/index.json") {}

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function mint(address[] memory accounts)
        public
        onlyOwner
    {
        uint256 amount = 1;
        uint256 id = 1;
        bytes memory data = "";

        for (uint256 i = 0; i < accounts.length; ++i) {
            address to = accounts[i];
            if (balanceOf(to, id) == 0) {
                _mint(to, id, amount, data);
            } else {
                mintErrorAddresses.push(to);
            }
        }

        if (mintErrorAddresses.length > 0) {
            revert MintError(mintErrorAddresses);
        }
    }
}
