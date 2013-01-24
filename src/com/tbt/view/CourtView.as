package com.tbt.view
{
	import com.greensock.TweenMax;
	import com.tbt.constants.Layout;
	import com.tbt.constants.TileTypes;
	import com.tbt.events.TileEvent;
	import com.tbt.model.BallData;
	import com.tbt.model.PlayerData;
	import com.tbt.model.data.TurnData;
	import com.tbt.view.character.CharacterView;
	import com.tbt.view.character.OpponentView;
	import com.tbt.view.character.PlayerView;
	import com.tbt.view.tiles.CourtTile;

	import flash.display.Sprite;
	import flash.events.MouseEvent;


	/**
	 * @author Tom Danvers - tom@tomdanvers.com
	 */
	public class CourtView extends Sprite
	{
		private var _tiles : Vector.<CourtTile>;
		private var _validShotTiles : Vector.<CourtTile>;
		private var _validMovementTiles : Vector.<CourtTile>;
		private var _charactersMap : Object;
		
		private var _player : PlayerView;
		private var _opponent : OpponentView;
		private var _lines : CourtLines;
		private var _ball : BallView;
		
		public function CourtView(playerAtTop : Boolean, playerId : String, opponentId : String)
		{
			_tiles = new Vector.<CourtTile>();
			_validMovementTiles = new Vector.<CourtTile>();
			_validShotTiles = new Vector.<CourtTile>();
			
			var tile : CourtTile;
			for (var y : int = 0; y < Layout.COURT_HEIGHT; y++) {
				for (var x : int = 0; x < Layout.COURT_WIDTH; x++) {
					tile = new CourtTile(x, y);
					tile.type = getTypeFromPosition(x,y);
					tile.x = tile.gridX * Layout.TILE_WIDTH;
					tile.y = tile.gridY * Layout.TILE_HEIGHT;
					tile.addEventListener(MouseEvent.CLICK, onTileClick);
					addChild(tile);
					_tiles.push(tile);
					if(tile.gridY >= Layout.COURT_HEIGHT >> 1){
						if(playerAtTop){
							_validShotTiles.push(tile);
						}else{
							_validMovementTiles.push(tile);
						}
					}else{
						if(playerAtTop){
							_validMovementTiles.push(tile);
						}else{
							_validShotTiles.push(tile);
						}
					}
				}
			}
			addChild(_lines = new CourtLines());
			addChild(_player = new PlayerView(playerId));
			addChild(_opponent = new OpponentView(opponentId));
			addChild(_ball = new BallView());
			
			_charactersMap = {};
			_charactersMap[playerId] = _player;
			_charactersMap[opponentId] = _opponent;
		}

		private function onTileClick(event : MouseEvent) : void
		{
			var tile : CourtTile = event.currentTarget as CourtTile;
			dispatchEvent(new TileEvent(TileEvent.CLICK, tile));
		}

		private function getTypeFromPosition(x : int, y : int) : String
		{
			return TileTypes.COURT_LAYOUT[y][x];
		}

		public function updatePlayer(playerData : PlayerData, instant : Boolean) : void
		{
			gridPositionToPosition(_player, playerData.gridX, playerData.gridY, instant ? 0:.75);
		}

		public function updateOpponent(opponentData : PlayerData, instant : Boolean) : void
		{
			gridPositionToPosition(_opponent, opponentData.gridX, opponentData.gridY, instant ? 0:.75);
		}
		
		public function updateBall(ballData : BallData, instant : Boolean) : void
		{
			gridPositionToPosition(_ball, ballData.gridX, ballData.gridY, instant ? 0:.5);
		}

		private function gridPositionToPosition(item : Sprite, gridX : int, gridY : int, duration : Number = 1) : void
		{
			TweenMax.killTweensOf(item);
			TweenMax.to(item, duration, {x:gridX * Layout.TILE_WIDTH, y:gridY * Layout.TILE_HEIGHT});
		}

		public function get validShotTiles() : Vector.<CourtTile>
		{
			return _validShotTiles;
		}

		public function get validMovementTiles() : Vector.<CourtTile>
		{
			return _validMovementTiles;
		}

		public function showMoveDistances(centreX : int, centreY : int) : void
		{
			var tile : CourtTile;
			for (var i : int = 0; i < _validMovementTiles.length; i++) {
				tile = _validMovementTiles[i];
				tile.value = Math.abs(centreX - tile.gridX) + Math.abs(centreY - tile.gridY);
			}
		}
		
		public function getTileRing(gridX : int, gridY : int, radius : int) : Vector.<CourtTile>
		{
			trace("CourtView.getTileRing(",gridX, gridY, radius,")");
			var tiles : Vector.<CourtTile> = new Vector.<CourtTile>();
			if(radius == 0){
				tiles.push(getTile(gridX, gridY));
			}else{
				for (var h : int = gridX - radius; h <= gridX + radius; h++) {
					tiles.push(getTile(h, gridY - radius));
					tiles.push(getTile(h, gridY + radius));
				}
				for (var v : int = gridY - radius + 1; v < gridY + radius; v++) {
					tiles.push(getTile(gridX - radius, v));
					tiles.push(getTile(gridX + radius, v));
				}
			}
			return tiles;
		}
		
		public function getTile(gridX : int, gridY : int) : CourtTile
		{
			return _tiles[Layout.COURT_WIDTH*gridY + gridX];
		}
		
		public function clearMoveDistances() : void
		{
			var tile : CourtTile;
			for (var i : int = 0; i < _validMovementTiles.length; i++) {
				tile = _validMovementTiles[i];
				tile.label = null;
			}
		}

		public function positionPlayer(data : PlayerData) : void
		{
			var player : CharacterView = _charactersMap[data.id];
			player.x = data.gridX * Layout.TILE_WIDTH;
			player.y = data.gridY * Layout.TILE_HEIGHT;
		}
		
		public function positionBall(data : BallData) : void
		{
			_ball.x = data.gridX * Layout.TILE_WIDTH;
			_ball.y = data.gridY * Layout.TILE_HEIGHT;
		}
		
		public function showTurn(turn : TurnData, callback : Function) : void
		{
			var player : CharacterView = _charactersMap[turn.playerId];
			TweenMax.killTweensOf(player);
			TweenMax.killTweensOf(_ball);
			if(turn.preMove)TweenMax.to(player, 1, {x:turn.preMove.gridX * Layout.TILE_WIDTH, y:turn.preMove.gridY * Layout.TILE_HEIGHT, delay : .5});
			TweenMax.to(_ball, .75, {x:turn.shot.gridX * Layout.TILE_WIDTH, y:turn.shot.gridY * Layout.TILE_HEIGHT, delay : 1.75});
			TweenMax.to(player, 1, {x:turn.postMove.gridX * Layout.TILE_WIDTH, y:turn.postMove.gridY * Layout.TILE_HEIGHT, delay:2, onComplete:callback});
		}

		public function get tiles() : Vector.<CourtTile>
		{
			return _tiles;
		}
	}
}
