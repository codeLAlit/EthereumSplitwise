pragma solidity ^0.5.0;

// FROM = A
// TO = B

contract Splitwise {
    
    struct User{
        address hash;
        uint paid;
        uint used;
        int net;
        
    }
    
    struct Event{
        string name;
        uint money;
        address creator;
    }
    
    Event[] private events;
    User[] private users;
    
    modifier onlyIfItemExists(uint eventID) {
        require(events[eventID].creator != address(0), "Event does not exists!");
        _;
    }
    
    function userExists(address sender) private returns(int){
        int index=-1;
        for(uint i=0; i<users.length; i++){
            if(users[i].hash==sender){
                index=int(i);
                break;
            }
        }
        return (index);
        
    }
    function addEvent(string memory name) public{
         events.push(Event({
             name:name,
             money: 0,
             creator: msg.sender
         }));
    }
    
    function addAmount(uint eventID, uint money) public onlyIfItemExists(eventID){
        Event storage eve=events[eventID];
        eve.money=eve.money+money;
        
        int index=userExists(msg.sender);
        if(index!=-1){
            User memory use=users[uint(index)];
            use.net=int(money);
            use.paid=money;
            
        }
        else{
            users.push(User({
                hash:msg.sender,
                paid:money,
                used:0,
                net:int(money)
            }));
           
        }
        
    }
    
    function showEventStatus(uint eventID) public view onlyIfItemExists(eventID) returns(string memory, uint, address){
        Event storage eve=events[eventID];
        
        return(eve.name, eve.money, eve.creator);
    }
    
    function fetchMoney(uint eventID, uint money) public onlyIfItemExists(eventID) {
        Event storage eve=events[eventID];
        require(eve.money>uint(money), "Not Enough balance!!");
        int index=userExists(msg.sender);
        if(index!=-1){
            User memory use=users[uint(index)];
            use.used=use.used+money;
            use.net=use.net-int(money);
            eve.money=eve.money-money;
            
        }
        else{
            users.push(User({
                hash:msg.sender,
                paid:0,
                used:money,
                net:int(0-money)
            }));
            eve.money=eve.money-money;
        }
       
    }
    
    function getLog() public view returns(address, uint ,uint ,int){
        for (uint i=0; i<users.length; i++){
            User storage use=users[i];
            return(use.hash, use.paid, use.used, use.net);
        }
    }
    
    function getUserlog() public view returns(address, uint ,uint ,int){
        for (uint i=0; i<users.length; i++){
            if(msg.sender==users[i].hash){
                return (users[i].hash, users[i].paid, users[i].used, users[i].net);
                break;
            }
            
        }
        return (address(0), 0, 0, 0);
    }
    
}
