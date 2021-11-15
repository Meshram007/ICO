// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

import "ERC20.sol";

contract ICO is ERC20{
    address public admin;
    uint public initialRate = 10**16;  // rate is scaled by 10**18;
    uint public CureentRate;
    uint public totalTokenSupply = 100*10**24; //scaled by 10**18;
    uint public Token = totalTokenSupply / 100*10**24;
    uint public icoStartTime;
    uint public icoEndTime;

    
  /**
   * @dev fallback function to receive the amount
   */
  receive() external payable {
  }
  
    constructor(uint256 _icoStart, uint256 _icoEnd) ERC20("Token", "Token") {
        admin = msg.sender;
        require(_icoStart != 0 && _icoEnd != 0 && _icoStart < _icoEnd);
        icoStartTime = _icoStart;
        icoEndTime = _icoEnd;
    }
    
  /**
   * @dev set the modifier only to admin 
   */
    modifier onlyadmin {
        require(msg.sender == admin, "Olny Admin Can");
        _;
    }
    
    
  /**
   * @dev chnage the current rate for the second and reaming tokens
   * @param  _Ratefactor multiplying factor used to chnage the rate
   */
    function changeRate(uint _Ratefactor) public onlyadmin returns(uint) {
        require(initialRate < CureentRate);
        require(CureentRate > 0);
        CureentRate = initialRate * _Ratefactor;
        return CureentRate;
    }


  /**
   * @dev this function used to Pre-sale Token : 30 Million 
   * @param  buyer Address performing the token purchase
   * @param  _tokensToBuy number of tokens to buy
   */
  function buyTokenFirst(address buyer, uint _tokensToBuy) public onlyadmin returns(address, uint){
      require(block.timestamp < icoEndTime && block.timestamp > icoStartTime);
      require(totalTokenSupply >  70*10**24, "Pre-sale Token Quantity for initialRate completed: 30 Million");
      uint tokensToBuy = _tokensToBuy * Token;
      uint AmountToPay = _tokensToBuy * initialRate * Token;
      transfer(address(this), AmountToPay);
      transfer(buyer, tokensToBuy);
      totalTokenSupply -= tokensToBuy;
      return (buyer, tokensToBuy);
  }
  
  
  /**
   * @dev this function used to Seed-sale Token : 50 Million 
   * @param  buyer Address performing the token purchase
   * @param  _tokensToBuy number of tokens to buy
   */
  function buyTokenSecond(address buyer, uint _tokensToBuy) public onlyadmin returns(address, uint){
      require(block.timestamp < icoEndTime && block.timestamp > icoStartTime);
      require(totalTokenSupply >  20*10**24, "seed-sale Token Quantity for CureentRate(0.02) completed: 50 Million");
      uint tokensToBuy = _tokensToBuy * Token;
      uint AmountToPay = _tokensToBuy * CureentRate * Token;
      transfer(address(this), AmountToPay);
      transfer(buyer, tokensToBuy);
      totalTokenSupply -= tokensToBuy;
      return (buyer, tokensToBuy);
  }
  
  
  /**
   * @dev this function used to remaining Token : 20 Million 
   * @param  buyer Address performing the token purchase
   * @param  _tokensToBuy number of tokens to buy
   */
  function buyTokenFinal(address buyer, uint _tokensToBuy) public onlyadmin returns(address, uint){
      require(block.timestamp < icoEndTime && block.timestamp > icoStartTime);
      require((totalTokenSupply <  20*10**24) || (totalTokenSupply > 0), 
            "final-sale Token Quantity for changedRate completed: 20 Million");
      uint tokensToBuy = _tokensToBuy * Token;
      uint AmountToPay = _tokensToBuy * CureentRate * Token;
      transfer(address(this), AmountToPay);
      transfer(buyer, tokensToBuy);
      totalTokenSupply -= tokensToBuy;
      return (buyer, tokensToBuy);
  }
}