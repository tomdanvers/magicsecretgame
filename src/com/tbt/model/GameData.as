package com.tbt.model
{
	import com.tbt.constants.CourtSides;
	import com.tbt.events.GameDataEvent;
	import com.tbt.model.data.TurnData;

	import flash.events.EventDispatcher;
	/**
	 * @author Tom Danvers - tom@tomdanvers.com
	 */
	public class GameData extends EventDispatcher
	{
		public var turns : Vector.<TurnData>;
		
//		public var ball : BallData;
		public var player1 : PlayerData;
		public var player2 : PlayerData;
		public var playerCurrent : PlayerData;
		public var playerServing : PlayerData;
		
		private var _playerMap : Object;
		
		public function init(player1 : PlayerData, player2 : PlayerData) : void
		{
			_playerMap = {};
			
			this.player1 = player1;
			_playerMap[player1.id] = player1;
			
			this.player2 = player2;
			_playerMap[player2.id] = player2;
			
			this.playerServing = this.playerCurrent = player1;
			
//			this.ball = ball;

			this.turns = new Vector.<TurnData>();

			reset();
		}

		public function reset() : void
		{
			player1.gridX = 7;
			player1.gridY = 25;
			
			player2.gridX = 8;
			player2.gridY = 4;
			
			ball.gridX = playerServing.gridX;
			ball.gridY = playerServing.gridY + (playerServing.courtSide == CourtSides.BOTTOM ? 1 : -1);
			
			dispatchEvent(new GameDataEvent(GameDataEvent.RESET));
		}
		
		public function endTurn(turn : TurnData) : void
		{
			turns.push(turn);
			
			playerCurrent = turn.playerData.opponent;
		}
		
		public function getLastTurn() : TurnData
		{
			return turns.length > 0 ? turns[turns.length-1] : null;
		}
		
		public function getLastShot() : ShotData
		{
			var shot : ShotData = null;
			var lastTurn : TurnData = getLastTurn();
			if (lastTurn) {
				shot = lastTurn.shot;
			}
			return shot;
		}
	}
}
