package com.tbt.view
{
	import com.tbt.constants.Gameplay;
	import com.tbt.events.GameDataEvent;
	import com.tbt.events.TileEvent;
	import com.tbt.model.GameData;
	import com.tbt.model.PlayerData;
	import com.tbt.model.data.MoveData;
	import com.tbt.model.data.ShotData;
	import com.tbt.model.data.TurnData;
	import com.tbt.utils.TextBitmap;
	import com.tbt.utils.TextFormats;
	import com.tbt.view.tiles.CourtTile;
	import com.tbt.view.ui.ValueSlider;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;

	/**
	 * @author Tom Danvers - tom@tomdanvers.com
	 */
	public class GameView extends Sprite
	{
		private static const WAITING : String = "Waiting";
		private static const WATCHING_MOVE : String = "Watching Opponent's Move";
		private static const PRE_MOVE : String = "Pre Shot Move";
		private static const SHOT : String = "Shot";
		private static const POST_MOVE : String = "Post Shot Move";
		
		private var _gameData : GameData;
		private var _turnData : TurnData;
		private var _playerData : PlayerData;

		private var _poller : Timer;
		private var _waiting : WaitingView;
		private var _court : CourtView;
		
		private var _state : String;
		private var _labelTitle : TextBitmap;
		private var _labelAP : TextBitmap;
		private var _sliderAccuracy : ValueSlider;
		private var _sliderPower : ValueSlider;
		private var _sliderGrunt : ValueSlider;
		
		public function GameView(data : GameData, player : PlayerData)
		{
			_gameData = data;
			_gameData.addEventListener(GameDataEvent.RESET, onGameDataReset);
			_playerData = player;
			
			_poller = new Timer(1000);
			_poller.addEventListener(TimerEvent.TIMER, onPoll);
			_poller.start();
			
			mouseEnabled = false;
			
			addChild(_court = new CourtView(_playerData));
			_court.positionPlayer(_gameData.player1);
			_court.positionPlayer(_gameData.player2);
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

		private function onGameDataReset(event : GameDataEvent) : void
		{
			_court.updatePlayer(_playerData, true);
			_court.updateOpponent(_playerData.opponent, true);
			if(_turnData && _turnData.shot){
				_court.updateBall(_turnData.shot, true);
			}else{
				_court.positionBall(new ShotData(_gameData.playerServing.gridX, _gameData.playerServing.gridY, _gameData.playerServing.gridX, _gameData.playerServing.gridY, 0));
			}
		}
		
		private function onPoll(event : TimerEvent) : void
		{
			if(_gameData.playerCurrent == _playerData){
				if(_turnData == null) turnStart();
			}else{
				if(_turnData != null) turnEnd();
			}
		}

		private function turnStart() : void
		{
			trace("GameView.turnStart(",_playerData.id,")");
			
			_turnData = new TurnData(_playerData);
			mouseEnabled = true;
			_waiting.visible = false;
			
			changeActionPoints(10);
			
			if(_gameData.getLastTurn()){
				changeState(WATCHING_MOVE);
			}else{
				changeState(SHOT);
			}
		}

		private function turnEnd() : void
		{
			trace("GameView.turnEnd(",_playerData.id,")");
			_turnData = null;
			mouseEnabled = false;
			_waiting.visible = true;

			changeState(WAITING);
		}

		private function changeState(state : String) : void
		{
			_state = state;
			_labelTitle.text = "Player "+_playerData.id + " : " + _state;
			
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
			var turn : TurnData = _gameData.getLastTurn();
			if(turn){
				_court.showTurn(turn, turnShown);
			}else{
				changeState(PRE_MOVE);
			}
		}

		private function turnShown() : void
		{
			var turn : TurnData = _gameData.getLastTurn();
			trace("GameView.turnShown(SHOWN PLAYER LOST POINT:",turn.playerLostPoint,")");
			if(turn.playerLostPoint){
				_gameData.playerServing = turn.playerData.opponent;
				_gameData.reset();
				
				changeState(SHOT);
			}else{
				changeState(PRE_MOVE);
			}
		}
		
		private function statePreMove() : void
		{
			_court.showMoveDistances(_playerData.gridX, _playerData.gridY);
		}
		
		private function actionPreMove(tile : CourtTile) : void
		{
			if(!tileIsValid(tile, _court.validMovementTiles)) return;
			if(tile.value > _playerData.ap) return;
			
			_turnData.preMove = new MoveData(tile.gridX, tile.gridY, tile.value);
			_playerData.gridX = _turnData.preMove.gridX;
			_playerData.gridY = _turnData.preMove.gridY;
			changeActionPoints(- _turnData.preMove.cost);
			changeState(SHOT);
		}

		private function stateShot() : void
		{
			_court.clearMoveDistances();
			_court.showAccuracyValues();
		}
		
		private function actionShot(targetTile : CourtTile) : ShotData
		{
			var accuracyValue : Number = targetTile.accuracyValue;
			trace("GameView.actionShot(",targetTile, accuracyValue,")");
			var actualTile : CourtTile;
			if(accuracyValue >= Math.random()){
				actualTile = targetTile;
			}else{
				var possibleTiles : Vector.<CourtTile> = _court.getTileRing(targetTile.gridX, targetTile.gridY, 1);
				actualTile = possibleTiles[Math.floor(possibleTiles.length * Math.random())];
			}
			
			_court.playHitSound();
					
			var shotSuccessful : Boolean = true;
			if(_gameData.playerServing == null){
				// Shot must be in court
				shotSuccessful = tileIsValid(actualTile, _court.validCourtTiles);
			}else{
				// Shot must be in service area
				shotSuccessful = tileIsValid(actualTile, _court.validServiceLeftTiles) || tileIsValid(actualTile, _court.validServiceRightTiles);
			}
			
			
			const POWER : uint = 2;		// TODO: Based on shot user selected
			_court.hideAccuracyValues();
			var finalBallPosition : Point = calculateFinalPosition(
				new Point(actualTile.gridX, actualTile.gridY), 
				new Point(_playerData.gridX, _playerData.gridY), 
				POWER
			);
			
			_turnData.shot = new ShotData(actualTile.gridX, actualTile.gridY, finalBallPosition.x, finalBallPosition.y, POWER);
			changeActionPoints(-_turnData.shot.cost);
			
			_turnData.playerLostPoint = !shotSuccessful;

			_court.hideAccuracyValues();

			if(shotSuccessful){
				changeState(POST_MOVE);
			}else{
				endTurn();
			}
			
			return _turnData.shot;
		}
		private function calculateFinalPosition(bounceTile : Point, playerPosition:Point, power : int) : Point {
		 	var dx:Number = bounceTile.x - playerPosition.x;
    		var dy:Number = bounceTile.y - playerPosition.y;
    		var angle : Number = Math.atan2(dy,dx);
			
			const BASE_POWER_MODIFIER : uint = 2;
			var position : Point = Point.polar(BASE_POWER_MODIFIER * power, angle);
			position = bounceTile.add(position);
			position.x = Math.round(position.x);
			position.y = Math.round(position.y);
			return position;
		}

		private function statePostMove() : void
		{
			_court.showMoveDistances(_playerData.gridX, _playerData.gridY);
		}
		
		private function actionPostMove(tile : CourtTile) : void
		{
			var player : PlayerData = _playerData;
			
			if(!tileIsValid(tile, _court.validMovementTiles)) return;
			if(tile.value > player.ap) return;
			
			_turnData.postMove = new MoveData(tile.gridX, tile.gridY, tile.value);
			player.gridX = _turnData.postMove.gridX;
			player.gridY = _turnData.postMove.gridY;
			changeActionPoints(- _turnData.postMove.cost);
			if(_gameData.playerServing) _gameData.playerServing = null;
			
			for each (var t : CourtTile in _court.tiles) {
				t.alpha = 1;	
			}
			
			endTurn();
		}

		private function endTurn() : void
		{
			_gameData.endTurn(_turnData);
			changeState(WAITING);
		}
		
		private function stateWaiting() : void
		{
			_court.clearMoveDistances();
		}

		private function onTileClicked(event : TileEvent) : void
		{
			var player : PlayerData = _playerData;
			
			var tile : CourtTile = event.tile;
			var shot : ShotData = null;
			switch(_state){
				case PRE_MOVE:
					actionPreMove(tile);
					break;
				case SHOT:
					shot = actionShot(tile);
					break;
				case POST_MOVE:
					actionPostMove(tile);
					break;
				default:
					trace("GameView.onTileClicked(",tile,")");
			}
			if (!shot)
				shot = _gameData.getLastShot();
				
			_court.updatePlayer(player, false);
			if (shot)
				_court.updateBall(shot, false);
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
			_playerData.ap += diff;
			updateActionPointsLabel();
		}

		private function updateActionPointsLabel() : void
		{
			_labelAP.text = 'AP:'+_playerData.ap;
		}
	}
}
