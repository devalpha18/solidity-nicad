/**
 *Submitted for verification at Etherscan.io on 2019-08-09
*/

pragma solidity ^0.5.1;

contract MatchingToken{
    mapping (address => uint256) public balanceOf;
    mapping (address => bool) private transferable;
    mapping(address => mapping (address => uint256)) allowed;
    
    uint256 private _totalSupply=3000000000000000000000000000;
    string private _name= "MatchingToken";
    string private _symbol= "MAT";
    uint256 private _decimals = 18;
    address private _administrator = msg.sender;
    
    constructor () public {
            balanceOf[msg.sender] = _totalSupply;
        }

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

        
    function name() public view returns (string memory) {
        return _name;
    }
    
    function symbol() public view returns (string memory) {
        return _symbol;
    }
    function decimals() public view returns (uint256) {
        return _decimals;
    }
    
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }
    
    function _transfer(address _from, address _to, uint256 _value) internal {
        require(balanceOf[_from]>=_value);
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        require(transfercheck(_from) == true);
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
    }
    
    
    function transfer(address to, uint256 value) public {
        _transfer(msg.sender, to, value);
    }
    
    function transferFrom(address _from, address _to, uint256 amount) public {
         
       require(allowed[_from][msg.sender]>=amount);
       allowed[_from][msg.sender] -= amount;
       _transfer(_from,_to,amount);
    }
    
    function transfercheck(address check) internal returns(bool) {
        if (transferable[check]==false){
            return true;
        }
        return false;
    }
    
    
    function approve(address spender, uint256 _value) public returns(bool){
        require(balanceOf[msg.sender]>=_value);
        allowed[msg.sender][spender] = _value;
        emit Approval(msg.sender, spender, _value);
        
    }

    function lock(address lockee) public {
        require(msg.sender == _administrator);
        transferable[lockee] = true;
    }
    
    function unlock(address unlockee) public {
        require(msg.sender == _administrator);
        transferable[unlockee] = false;
    }
    
    function lockcheck(address checkee) public view returns (bool){
        return transferable[checkee];
    }
    
    
    function _burn(address account, uint256 value) private {
        require(account == _administrator);
        require(msg.sender == _administrator);
        require(balanceOf[account]>value);
        require(_totalSupply>value);
        _totalSupply -= value;
        balanceOf[account] -=value;
    }
    
    function _addsupply(address account, uint256 value) private {
        require(account == _administrator);
        require(msg.sender == _administrator);
        _totalSupply += value;
        balanceOf[account] +=value;
    }
    
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }
    
    function addsupply(uint256 amount) public {
        _addsupply(msg.sender, amount);
    }
    
    
    
}