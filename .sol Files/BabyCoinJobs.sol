pragma solidity ^0.5.0;

import "./Project3.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC721/ERC721Full.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/drafts/Counters.sol";

contract JobRegistry is ERC721Full {

    constructor() ERC721Full("BabyCoin","BABY") public { }

    using Counters for Counters.Counter;
    Counters.Counter token_ids;

    struct Babysitter{
        string parent_name;
        string street_address;
        uint rate_offered;
    } 
    
    mapping(uint => Babysitter) public JobListings;

    event JobCompletion(uint token_id, uint appraisal_value, string report_uri);

    function registerJob(address owner, string memory parent_name, string memory street_address, uint initial_value, string memory token_uri) public returns(uint) {
        token_ids.increment();
        uint token_id = token_ids.current();

        _mint(owner, token_id);
        _setTokenURI(token_id, token_uri);

        JobListings[token_id] = Babysitter(parent_name, street_address, initial_value);

        return token_id;
    }
    
    // function ViewListings() public returns(memory) {
    //    return JobListings; }
    
    
    function newListing(uint token_id, uint new_value, string memory report_uri) public returns(uint) {
        JobListings[token_id].rate_offered = new_value;

        emit JobCompletion(token_id, new_value, report_uri);

        return JobListings[token_id].rate_offered;
    }
}
