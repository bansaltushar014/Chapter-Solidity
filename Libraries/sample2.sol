pragma solidity ^0.5.11;

library MyLibrary {

struct Player {
    uint score;
}

function incrementScore(Player storage _player, uint points) internal returns(uint){
  _player.score += points;
  return _player.score; 
    }
	
}

contract MyContract {

  using MyLibrary for MyLibrary.Player;
  mapping (uint => MyLibrary.Player) players;

  function foo() external {
    players[0].score = players[0].incrementScore (10);
  }

  function get() external view returns(uint){
      return players[0].score;
  }
