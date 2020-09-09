pragma solidity ^0.5.12;

import "./IERC721.sol";
import "./SafeMath.sol";

contract Kittycontract is IERC721 {
    using SafeMath for uint256;

    string public constant _name = "Kitty";
    string public constant _symbol = "KIT";

    struct Kitty {
        uint256 dna;        
        uint64 birthTime;
        uint32 momId;
        uint32 dadId;
        uint16 generation;
    }

    Kitty[] kitties;

    mapping(address => uint256) ownerTokenCount;
    mapping(uint256 => address) kittyOwner;

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance) {
        return ownerTokenCount[owner];
    }

    /*
     * @dev Returns the total number of tokens in circulation.
     */
    function totalSupply() external view returns (uint256 total) {
        return kitties.length;
    }

    /*
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory tokenName) {
        return _name;
    }

    /*
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory tokenSymbol) {
        return _symbol;
    }

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner) {
        require(tokenId < kitties.length, "Kitty does not exist");

        return kittyOwner[tokenId];
    }


     /* @dev Transfers `tokenId` token from `msg.sender` to `to`.
     *
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - `to` can not be the contract address.
     * - `tokenId` token must be owned by `msg.sender`.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 tokenId) external {
        require(address(0) != to, "Invalid address");
        require(to != msg.sender, "Cannot send to yourself");
        require(to != address(this), "Cannot send to the contract address");
        require(tokenId < kitties.length, "Kitty does not exist");
        require(kittyOwner[tokenId] == msg.sender, "You do not own this kitty");

        ownerTokenCount[msg.sender] = ownerTokenCount[msg.sender].sub(1);
        ownerTokenCount[to] = ownerTokenCount[to].add(1);
        kittyOwner[tokenId] = to;

        emit Transfer(msg.sender, to, tokenId);
    }
}