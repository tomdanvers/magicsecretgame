package com.tbt.view
{
	import com.tbt.constants.Gameplay;
	import com.tbt.view.ui.ValueSlider;
	import com.tbt.events.TileEvent;
	import com.tbt.model.BallData;
	import com.tbt.model.GameData;
	import com.tbt.model.PlayerData;
	import com.tbt.model.data.MoveData;
	import com.tbt.model.data.ShotData;
	import com.tbt.model.data.TurnData;
	import com.tbt.utils.TextBitmap;
	import com.tbt.utils.TextFormats;
	import com.tbt.view.tiles.CourtTile;

	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author Tom Danvers - tom@tomdanvers.com
	 */
	public class GameView extends Sprite
	{
		private static var SERVING : Boolean = true;
		
		private static const WAITING : String = "Waiting";
		private static const WATCHING_MOVE : String = "Watching Opponent's Move";
		private static const PRE_MOVE : String = "Pre Shot Move";
		private static const SHOT : String = "Shot";
		private static const POST_MOVE : String = "Post Shot Move";
		
		private var _data : GameData;
		private var _turnData : TurnData;
		private var _playerId : String;
		private var _opponentId : String;

		private var _poller : Timer;
		private var _waiting : WaitingView;
		private var _court : CourtView;
		
		private var _state : String;
		private var _labelTitle : TextBitmap;
		private var _labelAP : TextBitmap;
		private var _sliderAccuracy : ValueSlider;
		private var _sliderPower : ValueSlider;
		private var _sliderGrunt : ValueSlider;
		
		public function GameView(data : GameData, playerId : String, opponentId : String, playerAtTop : Boolean)
		{
			_data = data;
			_playerId = playerId;
			_opponentId = opponentId;
			
			_poller = new Timer(1000);
			_poller.addEventListener(TimerEvent.TIMER, onPoll);
			_poller.start();
			
			mouseEnabled = false;
			
			addChild(_court = new CourtView(playerAtTop, playerId, opponentId));
			_court.positionPlayer(_data.player1);
			_court.positionPlayer(_data.player2);
			_court.positionBall(_data.ball);
			_court.addEventListener(TileEvent.CLICK, onTileClicked);
			
			addChild(_labelTitle = new TextBitmap(TextFormats.GAME_LABEL));
			_labelTitle.x = _labelTitle.y = 10;
			
			addChild(_labelAP = new TextBitmap(TextFormats.AP_LABEL));
			_labelAP.x = _labelTitle.x;
			_labelAP.y = 40;
			
			addChild(_sliderAccuracy = new ValueSlider('Acc', 0, Gameplay.MAX_ACCURACY));
			addChild(_sliderPower = new ValueSlider('Pow', 0, Gameplay.MAX_POWER));
			addChild(_sliderGrunt = new ValueSlider('Grunt', 0, Gameplay.MAX_POWER));
			
			_sliderAccuracy.x = _sliderPower.x = _sliderGrunt.x = _labelTitle.x;
			_sliderAccuracy.y = _labelAP.y + _labelAP.height + 40;
			_sliderPower.y = _labelAP.y + _sliderPower.height + 10;
			_sliderGrunt.y = _sliderAccuracy.y + _sliderAccuracy.height + 10;
			
			addChild(_waiting = new WaitingView());
			
			changeState(WAITING);
		}
		
		private function onPoll(event : TimerEvent) : void
		{
			if(_data.playerCurrent.id == _playerId){
				if(_turnData == null) turnStart();
			}else{
				if(_turnData != null) turnEnd();
			}
		}

		private function turnStart() : void
		{
			trace("GameView.turnStart(",_playerId,")");
			
			_turnData = new TurnData(_playerId);
			mouseEnabled = true;
			_waiting.visible = false;
			
			changeActionPoints(10);
			
			_court.updatePlayer(_data.getPlayerById(_playerId), SERVING);
			_court.updateOpponent(_data.getPlayerById(_opponentId), SERVING);
			_court.updateBall(_data.ball, SERVING);
			
			if(SERVING){
				changeState(SHOT);
			}else{
				changeState(WATCHING_MOVE);
			}
		}

		private function turnEnd() : void
		{
			trace("GameView.turnEnd(",_playerId,")");
			_turnData = null;
			mouseEnabled = false;
			_waiting.visible = true;

			changeState(WAITING);
		}

		private function changeState(state : String) : void
		{
			_state = state;
			_labelTitle.text = "Player "+_playerId + " : " + _state;
			
			switch(_state){
				case WATCHING_MOVE:
					stateWatchingMove();
					break;
				case PRE_MOVE:
					statePreMove();
					break;
				case SHOT:
					stateShot();
					break;
				case POST_MOVE:
					statePostMove();
					break;
				case WAITING:
					stateWaiting();
					break;
				default:
			}
		}
		
		private function stateWatchingMove() : void
		{
			var turn : TurnData = _data.getLastTurn();
			if(turn){
				_court.showTurn(turn, turnShown);
			}else{
				changeState(PRE_MOVE);
			}
		}

		private function turnShown() : void
		{
			changeState(PRE_MOVE);
		}
		
		private function statePreMove() : void
		{
			_court.showMoveDistances(_data.getPlayerById(_playerId).gridX, _data.getPlayerById(_playerId).gridY);
		}
		
		private function actionPreMove(tile : CourtTile) : void
		{
			var player : PlayerData = _data.getPlayerById(_playerId);
			
			if(!tileIsValid(tile, _court.validMovementTiles)) return;
			if(tile.value > player.ap) return;
			
			_turnData.preMove = new MoveData(tile.gridX, tile.gridY, tile.value);
			player.gridX = _turnData.preMove.gridX;
			player.gridY = _turnData.preMove.gridY;
			changeActionPoints(- _turnData.preMove.cost);
			changeState(SHOT);
		}

		private function stateShot() : void
		{
			_court.clearMoveDistances();
			_court.showAccuracyValues();
		}
		
		private function actionShot(targetTile : CourtTile) : void
		{
			var ball : BallData = _data.ball;
			
			if(!tileIsValid(targetTile, _court.validShotTiles)) return;
			
			var accuracyValue : Number = targetTile.accuracyValue;
			trace("GameView.actionShot(",targetTile, accuracyValue,")");
			var actualTile : CourtTile;
			if(accuracyValue >= Math.random()){
				actualTile = targetTile;
			}else{
				var possibleTiles : Vector.<CourtTile> = _court.getTileRing(targetTile.gridX, targetTile.gridY, 1);
				actualTile = possibleTiles[Math.floor(possibleTiles.length * Math.random())];
			}
					
			var shotSuccessful : Boolean = true; // TODO Implement checks to see if shot was ok...
			if(SERVING){
				// Shot must be in service area
			}else{
				// Shot must be in court
			}
			
			if(shotSuccessful){
				_turnData.shot = new ShotData(actualTile.gridX, actualTile.gridY, 5);
				ball.gridX = _turnData.shot.gridX;
				ball.gridY = _turnData.shot.gridY;
				_court.hideAccuracyValues();
				changeActionPoints(-_turnData.shot.cost);
				changeState(POST_MOVE);
			}
		}

		private function statePostMove() : void
		{
			_court.showMoveDistances(_data.getPlayerById(_playerId).gridX, _data.getPlayerById(_playerId).gridY);
		}
		
		private function actionPostMove(tile : CourtTile) : void
		{
			var player : PlayerData = _data.getPlayerById(_playerId);
			
			if(!tileIsValid(tile, _court.validMovementTiles)) return;
			if(tile.value > player.ap) return;
			
			_turnData.postMove = new MoveData(tile.gridX, tile.gridY, tile.value);
			player.gridX = _turnData.postMove.gridX;
			player.gridY = _turnData.postMove.gridY;
			changeActionPoints(- _turnData.postMove.cost);
			changeState(WAITING);
			if(SERVING) SERVING = false;
			_data.addTurn(_turnData);
			_data.playerCurrent = _data.getPlayerById(_opponentId);
			
			for each (var t : CourtTile in _court.tiles) {
				t.alpha = 1;	
			}
		}
		
		private function stateWaiting() : void
		{
			_court.clearMoveDistances();
		}

		private function onTileClicked(event : TileEvent) : void
		{
			var player : PlayerData = _data.getPlayerById(_playerId);
			var ball : BallData = _data.ball;
			
			var tile : CourtTile = event.tile;
			switch(_state){
				case PRE_MOVE:
					actionPreMove(tile);
					break;
				case SHOT:
					actionShot(tile);
					break;
				case POST_MOVE:
					actionPostMove(tile);
					break;
				default:
					trace("GameView.onTileClicked(",tile,")");
			}
			_court.updatePlayer(player, false);
			_court.updateBall(ball, false);
		}

		private function tileIsValid(tile : CourtTile, tileSet : Vector.<CourtTile>) : Boolean
		{
			for (var i : int = 0; i < tileSet.length; i++) {
				if(tile.gridX == tileSet[i].gridX && tile.gridY == tileSet[i].gridY) return true;
			}
			return false;
		}

		private function changeActionPoints(diff : int) : void
		{
			_data.getPlayerById(_playerId).ap += diff;
			updateActionPointsLabel();
		}

		private function updateActionPointsLabel() : void
		{
			_labelAP.text = 'AP:'+_data.getPlayerById(_playerId).ap;
		}
	}
}
