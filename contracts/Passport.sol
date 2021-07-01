// SPDX-License-Identifier: MIT
pragma solidity >=0.5.16;

contract Passport {
    
    // Admin
    
    struct Admin{
        uint id;
        string username;
        uint pwd;
    }
    
    // PassWord
    
    struct Pass{
        string PassNumber;
        string Name;
        uint expireDate;
    }

    // Passports hash
    struct PassHash{
        bytes32 hashOfPass;
    }



    // Store expired Passports
    mapping(bytes32 => uint) public expires; // TODO - It is unnecessary i think
    mapping(bytes32 => bool) public expired; 

    // Store Passports
    mapping(uint => PassHash) public passhashes; // TODO - rename this. It holds ids of passhashes
    mapping(bytes32 => bool) public passhashes2; // TODO - rename this. It holds the passhashes
    

    // Store Admins
    // TODO - check if mappings can reducible
    mapping(uint => Admin) public adminsId;
    mapping(address => bool) public adminsAddress;
    mapping(uint => address) public adminIdToAddress;

    // TODO - check if there is unnecessary ones
    uint public adminCount      = 0;
    uint public passpCount      = 0;
    uint public expiredCount    = 0;

    // TODO - removeable
    string returnMessage; 
    bool returnBool;

    // Default admins are created
    constructor () public {

        addDefaultAdmin(0x5e6a57C7aAff1aE1fb78Cfa6036E569070c8602a, "Ahmet", 123);
        addDefaultAdmin(0xf604eB5610a9Cd54d96355126177E8BEd0Bb8DAb, "Yusuf", 123);
    }

    // write hash of passport on blockchain
    event hashedEvent (bytes32 indexed _hashedpass);
    
    // Default admin creator function
    function addDefaultAdmin(address _newAdminAddress, string memory _username, uint _pwd) public {
        // require that only adminsId can create new admin.
        adminCount++;

        adminsId[adminCount] = Admin(adminCount, _username, _pwd);
        adminsAddress[_newAdminAddress] = true;
        adminIdToAddress[adminCount] = _newAdminAddress;
    }

    // Adds admin (requires an admin to do this)
    function addAdmin(address _newAdminAddress, string memory _username, uint _pwd) public {
        // require that only adminsId can create new admin.
        require(adminsAddress[msg.sender]);

        adminCount++;

        adminsId[adminCount] = Admin(adminCount, _username, _pwd);
        adminsAddress[_newAdminAddress] = true;
        adminIdToAddress[adminCount] = _newAdminAddress;
    }

    /* TODO - addPassport ile admin yeni bir passport oluşturup hashi kişiye özel 
        oluşturulan bir hesaba atancak 
    */

    // Adds passports hash on blockchain (requires an admin to do this, requires that there is no exact 
    // same hash already on blockchain)
    function addPassport(string memory _PassNumber, string memory _name, uint _expireDate) public {
        require(adminsAddress[msg.sender]);
        bytes32 hashedPass = hash(_PassNumber, _name, _expireDate);

        require(!passhashes2[hashedPass]);
        passpCount++;

        expires[hashedPass] = _expireDate;

        // IDEA - Hash yeni oluşturulacak bir adrese tanımlanabilir.
        passhashes2[hashedPass] = true;
        passhashes[passpCount] = PassHash(hashedPass);
        emit hashedEvent(hashedPass);
        
    }

    // TODO - controlPass ile Passaport bilgileri kişiden alınıp hashi kişiye verilen adres ile doğrulanacak
    // Controls if there is a hash on blockchain which is exactly same as hash of given parameters 
    // requires that the passport not expired
    function controllPassport(string memory _PassNumber, string memory _name, uint _expireDate, uint _currentDate) public {
        //require(admins2[msg.sender]); // IDEA - Bence admin yerine herkes kontrol edebilmeli
        bytes32 hashedPass = hash(_PassNumber, _name, _expireDate);

        require(passhashes2[hashedPass], "This passport does never existed");
        
        require(!expired[hashedPass], "This passport already expired");

        require(_expireDate > _currentDate, "This passport expired");

        returnMessage = "This Passport is allowed.";
    }
    
    // TODO - This function not used yet. But it will be!
    function isAccountAdmin() public returns (bool) {
        if (adminsAddress[msg.sender] == true){ return true; }
        else {return false;}
    }
    
    
    
    
    // Hash
    function hash(string memory _PassNumber, string memory _name, uint _expireDate)
        public pure returns (bytes32)
    {
        return keccak256(abi.encodePacked(_PassNumber, _name, _expireDate));
    }



}
