pragma solidity 0.5.8;

contract ERC721{
    mapping(address => uint[]) ownerNFTs;
    mapping(address => uint) ownerNFTsCount;
    mapping(address => mapping(address => uint[]))approvedAddress;
    mapping(address => address[])approvedAll;
    mapping(uint => address) NFTowner;

    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    function balanceOf(address _owner) external view returns(uint){
        require(_owner != address(0));
        return ownerNFTsCount[_owner];
    }

    function ownerOf(uint256 _tokenId) external view returns(address){
        require(_tokenId != 0);
        return NFTowner[_tokenId];
    }

    function transfer(address _from, address _to, uint256 _tokenId) public payable{
        require(msg.sender == _from);
        require(_tokenId != 0);

        bool found = false;

        for (uint i = 0; i < ownerNFTs[_from].length; i++) {
            if (ownerNFTs[_from][i] == _tokenId) {
                found = true;
                delete ownerNFTs[_from][i];
            }

        }

        require(found);
        ownerNFTs[_to].push(_tokenId);
        NFTowner[_tokenId] = _to;
        ownerNFTsCount[_from] -= 1;
        ownerNFTsCount[_to] += 1;

// TODO Traverse mapping
        // for (uint i = 0; i < approvedAddress[_from].length; i++) {
        //     for (uint j = 0; j < approvedAddress[_from][i].length; j++) {
        //         if (approvedAddress[_from][i][j] == _tokenId) {
        //             delete approvedAddress[_from][i][j];
        //         }
        //     }
        // }
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) external payable{
        bool authorized = false;
        for (uint i = 0; i < approvedAll[_from].length; i++) {
            if (approvedAll[_from][i] == msg.sender) {
                authorized = true;
            }
        }
        if (!authorized) {
            for (uint i = 0; i < approvedAddress[_from][msg.sender].length; i++) {
                if (approvedAddress[_from][msg.sender][i] == _tokenId) {
                    authorized = true;
                }
            }
        }
        require(authorized);
        transfer(_from, _to, _tokenId);
        for (uint i = 0; i < approvedAddress[_from][msg.sender].length; i++) {
            if (approvedAddress[_from][msg.sender][i] == _tokenId) {
                delete approvedAddress[_from][msg.sender][i];
            }
        }

    }

    function approve(address _approved, uint256 _tokenId) external payable{
        require(_tokenId != 0);
        require(_approved != address(0));
        approvedAddress[msg.sender][_approved].push(_tokenId);
    }
    function setApprovalForAll(address _operator, bool _approved) external{
        require(_approved);
        require(_operator != address(0));
        approvedAll[msg.sender].push(_operator);
    }
    function getApproved(uint256 _tokenId) external view returns(address){
        require(_tokenId != 0);
        address[] memory approveArr;
        //TODO 
        // for (uint i = 0; i < approvedAddress[msg.sender].length; i++) {
        //     for (uint j = 0; j < approvedAddress[msg.sender][i].length; j++) {
        //         if (approvedAddress[msg.sender][i][j] == _tokenId) {
        //             approveArr.push(approvedAddress[msg.sender][i]);
        //         }
        //     }
        // }

    }
    function isApprovedForAll(address _owner, address _operator) external view returns(bool){
        for (uint i = 0; i < approvedAll[_owner].length; i++) {
            if (approvedAll[_owner][i] == _operator)
                return true;
        }
        return false;
    }
}