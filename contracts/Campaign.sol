pragma solidity ^0.4.0;

contract Campaign {
    uint256 public maxContributor;
    uint256 public minContributor;
    address public owner;
    bool public campaignEnd;
    bool public campaignSuccess;
    address[] private contributorIndex;
    address[] private publisherIndex;
    address tokenAddress;
    uint256 public reward;
     
    struct Contributor {
        string ipfsHash;
        string policy_id;
        string capsule;
        address contributorAddress;
        address publisherAddress;
        uint index;
    }
    
    struct PublisherData {
        uint256 contributionCount;
        uint256 index;
    }
    
    mapping(address => Contributor) private contributors;
    mapping(address => PublisherData) private publishers;
    
    event LogNewContributor (address indexed contributorAddress, address publisherAddress, string ipfsHash);
    event LogCampaignResult (address publisherAddress, uint256 contributionCount);
    event LogSendToken (address publisherAddress, uint256 contributionCount);
     
    constructor(uint256 _minContributor,uint256 _maxContributor, uint256 _reward) public {
        owner = msg.sender;
        minContributor = _minContributor;
        maxContributor = _maxContributor;
        reward = _reward;
        campaignEnd = false;
        campaignSuccess = false;
    }
    
    function isContributor(address userAddress) public constant returns(bool isIndeed) {
        if(contributorIndex.length == 0) return false;
        return (contributorIndex[contributors[userAddress].index] == userAddress);
    }
    
    function isPublisher(address publisherAddress) public constant returns(bool isIndeed) {
        if(publisherIndex.length == 0) return false;
        return (publisherIndex[publishers[publisherAddress].index] == publisherAddress);
    }
    
    function getTotalContributor() public constant returns(uint count){
        return contributorIndex.length;
    }
    
    function setTokenAddress(address _tokenAddress) public{
        require(msg.sender == owner);
        require(!campaignEnd);
        tokenAddress = _tokenAddress;
    }
    
    function contribute(address _contributorAddress, address _publisherAddress, string _policy_id,string _ipfsHash, string _capsule) public returns(uint index){
        require(msg.sender == owner);
        require(!campaignEnd);
        require(!isContributor(_contributorAddress));
        require(getTotalContributor()<maxContributor);
        
     
        contributors[_contributorAddress].policy_id = _policy_id;
        contributors[_contributorAddress].ipfsHash = _ipfsHash;
        contributors[_contributorAddress].capsule = _capsule;
        contributors[_contributorAddress].publisherAddress   = _publisherAddress;
        contributors[_contributorAddress].index     = contributorIndex.push(_contributorAddress)-1;
        
        emit LogNewContributor(_contributorAddress,_publisherAddress,_ipfsHash);
        
        publishers[_publisherAddress].contributionCount += 1;
        if(!isPublisher(_publisherAddress)){
            publishers[_publisherAddress].index = publisherIndex.push(_publisherAddress)-1;
        }
        
        return contributorIndex.length-1;
    }
    
    function getTotalContributorPublisher (address _publisherAddress)  public view returns(uint index){
        return publishers[_publisherAddress].contributionCount;
    }
    
    function endCampaign() public{
        require(msg.sender == owner);
        require(!campaignEnd);
        campaignEnd = true;
        
        // check getTotalContributor 
        if(getTotalContributor()>=minContributor){
            campaignSuccess = true;
            for (uint i = 0; i < publisherIndex.length; i++) {
               emit LogCampaignResult(publisherIndex[i], publishers[publisherIndex[i]].contributionCount);
            }
        }
        
    }
    
    function disburseReward() public {
        require(msg.sender == owner);
        require(campaignSuccess);
        
        for (uint i = 0; i < publisherIndex.length; i++) {
            uint pubContributor = getTotalContributorPublisher(publisherIndex[i]);
            uint _tokensToDistributePub =  pubContributor*reward* (10**18);
           emit LogSendToken(publisherIndex[i],_tokensToDistributePub);
        }
        
        for (uint j = 0; j < contributorIndex.length; j++) {
            uint _tokensToDistributeCont = reward* (10**18);
            emit LogSendToken(contributorIndex[j],_tokensToDistributeCont);
        }
        
    }
    
    function getDataContributor(address _contributorAddress) public view returns (string,string,string){
        require(msg.sender == owner);
        require(campaignSuccess);
        return (contributors[_contributorAddress].policy_id,contributors[_contributorAddress].ipfsHash,contributors[_contributorAddress].capsule);
    }
    
    function getAllContributors() public view returns (address[]){
        return contributorIndex;
    }
    
    function getAllPublishers() public view returns (address[]){
        return publisherIndex;
    }
    
    function getRewards(address chekAddress) public view returns (uint256){
       require(msg.sender == owner);
       require(campaignSuccess);
       if(isPublisher(chekAddress)){
           return getTotalContributorPublisher(chekAddress) *reward;
       }else if(isContributor(chekAddress)){
           return 1*reward;
       }else{
        return 0;
       }
    }
    
    function checkContribution(address chekAddress) public view returns (bool){
        if(isContributor(chekAddress)){
            return true;
        }else if(isPublisher(chekAddress)){
            return true;
        }else{
            return false;
        }
    }
    
}