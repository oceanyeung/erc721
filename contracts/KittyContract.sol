pragma solidity ^0.5.12;

import "./IERC721.sol";
import "./SafeMath.sol";
import "./Ownable.sol";

contract Kittycontract is IERC721, Ownable {
    using SafeMath for uint256;

    string public constant _name = "Kitty";
    string public constant _symbol = "KIT";

    event Birth(address owner, uint256 kittyId, uint256 momId, uint256 dadId, uint256 dna);

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

    function createKittyGen0(uint256 _dna) public onlyOwner {
        _createKitty(0, 0, 0, _dna, msg.sender);
    }

    function _createKitty(uint256 _momId, uint256 _dadId, uint256 _generation, uint256 _dna, address _owner) private returns (uint256) {
        Kitty memory _kitty = Kitty({
            dna: _dna,
            birthTime: uint64(now),
            momId: uint32(_momId),
            dadId: uint32(_dadId),
            generation: uint16(_generation)
        });

        uint256 newKittyId = kitties.push(_kitty) - 1;
        _transfer(address(0), _owner, newKittyId);

        emit Birth(_owner, newKittyId, _momId, _dadId, _dna);

        return newKittyId;
    }

    function getKitty(uint256 _id) external view returns(
        uint256 dna,
        uint256 birthTime,
        uint256 momId,
        uint256 dadId,
        uint256 generation,
        address owner
    ) {
        require(_id < kitties.length, "Kitty does not exist");

        Kitty storage kitty = kitties[_id];

        dna = kitty.dna;
        birthTime = uint256(kitty.birthTime);
        momId = uint256(kitty.momId);
        dadId = uint256(kitty.dadId);
        generation = uint256(kitty.generation);
        owner = kittyOwner[_id];
    }

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

    function _transfer(address from, address to, uint256 tokenId) internal {
        if (address(0) != from) {
            ownerTokenCount[from] = ownerTokenCount[from].sub(1);
        }
        ownerTokenCount[to] = ownerTokenCount[to].add(1);
        kittyOwner[tokenId] = to;

        emit Transfer(from, to, tokenId);
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

        _transfer(msg.sender, to, tokenId);
    }
}