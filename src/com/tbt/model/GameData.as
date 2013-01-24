package com.tbt.model
{
	import com.tbt.model.data.TurnData;
	/**
	 * @author Tom Danvers - tom@tomdanvers.com
	 */
	public class GameData
	{
		public var turns : Vector.<TurnData>;
		
		public var ball : BallData;
		public var player1 : PlayerData;
		public var player2 : PlayerData;
		public var playerCurrent : PlayerData;
		
		private var _playerMap : Object;
		
		public function init(player1 : PlayerData, player2 : PlayerData, ball : BallData) : void
		{
			_playerMap = {};
			
			this.player1 = player1;
			_playerMap[player1.id] = player1;
			
			this.player2 = player2;
			_playerMap[player2.id] = player2;
			
			this.playerCurrent = player1;
			
			this.ball = ball;
			
			this.turns = new Vector.<TurnData>();
		}

		public function getPlayerById(playerId : String) : PlayerData
		{
			return _playerMap[playerId];
		}
		
		public function addTurn(turn : TurnData) : void
		{
			turns.push(turn);
		}
		
		public function getLastTurn() : TurnData
		{
			return turns.length > 0 ? turns[turns.length-1] : null;
		}
	}
}
