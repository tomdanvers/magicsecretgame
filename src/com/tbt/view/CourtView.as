package com.tbt.view {
	import com.tbt.constants.CourtSides;
	import com.greensock.easing.Linear;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import com.greensock.TweenMax;
	import com.tbt.constants.Layout;
	import com.tbt.constants.TileTypes;
	import com.tbt.events.TileEvent;
	import com.tbt.model.PlayerData;
	import com.tbt.model.data.ShotData;
	import com.tbt.model.data.TurnData;
	import com.tbt.utils.DataMaps;
	import com.tbt.view.character.CharacterView;
	import com.tbt.view.character.OpponentView;
	import com.tbt.view.character.PlayerView;
	import com.tbt.view.tiles.CourtTile;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;


	/**
	 * @author Tom Danvers - tom@tomdanvers.com
	 */
	public class CourtView extends Sprite
	{
		[Embed(source='/../assets/bounce.mp3')]
		private const Bounce : Class;
		private var _bounceSound : Sound;
		
		[Embed(source='/../assets/hit.mp3')]
		private const Hit : Class;
		private var _hitSound : Sound;
		
		private var _tiles : Vector.<CourtTile>;
		private var _validShotTiles : Vector.<CourtTile>;
		private var _validCourtTiles : Vector.<CourtTile>;// Tiles that are valid mid game
		private var _validServiceLeftTiles : Vector.<CourtTile>;// Tiles that are valid serving left
		private var _validServiceRightTiles : Vector.<CourtTile>;// Tiles that are valid serving right
		private var _validMovementTiles : Vector.<CourtTile>;
		private var _charactersMap : Object;
		
		private var _player : PlayerView;
		private var _opponent : OpponentView;
		private var _lines : CourtLines;
		private var _bounce : BallView;
		private var _ball : BallView;
		private var _effectsBM : Bitmap;
		private var _effectsBMD : BitmapData;
		
		public function CourtView(playerData : PlayerData)
		{
			_tiles = new Vector.<CourtTile>();
			_validMovementTiles = new Vector.<CourtTile>();
			_validShotTiles = new Vector.<CourtTile>();
			_bounceSound = new Bounce();
			_hitSound = new Hit();
					
			_validCourtTiles = new Vector.<CourtTile>();
			_validServiceLeftTiles = new Vector.<CourtTile>();
			_validServiceRightTiles = new Vector.<CourtTile>();
			
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
						if(playerData.courtSide == CourtSides.BOTTOM){
							tile.accuracyValue = DataMaps.getAccuracyValue(tile.gridX, tile.gridY);
							_validShotTiles.push(tile);
							
							if(tile.type == TileTypes.COURT || tile.type == TileTypes.SERVICE_LEFT || tile.type == TileTypes.SERVICE_RIGHT) _validCourtTiles.push(tile);
							if(tile.type == TileTypes.SERVICE_LEFT) _validServiceLeftTiles.push(tile);
							if(tile.type == TileTypes.SERVICE_RIGHT) _validServiceRightTiles.push(tile);
						}else{
							_validMovementTiles.push(tile);
						}
					}else{
						if(playerData.courtSide == CourtSides.TOP){
							tile.accuracyValue = DataMaps.getAccuracyValue(tile.gridX, tile.gridY);
							_validShotTiles.push(tile);
							
							if(tile.type == TileTypes.COURT || tile.type == TileTypes.SERVICE_LEFT || tile.type == TileTypes.SERVICE_RIGHT) _validCourtTiles.push(tile);
							if(tile.type == TileTypes.SERVICE_LEFT) _validServiceLeftTiles.push(tile);
							if(tile.type == TileTypes.SERVICE_RIGHT) _validServiceRightTiles.push(tile);
						}else{
							_validMovementTiles.push(tile);
						}
					}
				}
			}
			addChild(_lines = new CourtLines());
			addChild(_player = new PlayerView(playerData));
			addChild(_opponent = new OpponentView(playerData.opponent));
			_effectsBMD = new BitmapData(Layout.VIEW_WIDTH, Layout.VIEW_HEIGHT, true, 0x00000000);
			addChild(_effectsBM = new Bitmap(_effectsBMD));
			addChild(_bounce = new BallView(0x8E9660));
			addChild(_ball = new BallView());
			_charactersMap = {};
			_charactersMap[playerData.id] = _player;
			_charactersMap[playerData.opponent.id] = _opponent;
			
			addEventListener(Event.ENTER_FRAME, onUpdate);
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
		
		public function updateBall(shot : ShotData, instant : Boolean) : void
		{
			gridPositionToPosition(_ball, shot.gridX, shot.gridY, instant ? 0:.5);
			gridPositionToPosition(_bounce, shot.bounceX, shot.bounceY, instant ? 0:.5);
		}

		private function gridPositionToPosition(item : Sprite, gridX : int, gridY : int, duration : Number = 1) : void
		{
			TweenMax.killTweensOf(item);
			TweenMax.to(item, duration, {x:gridX * Layout.TILE_WIDTH, y:gridY * Layout.TILE_HEIGHT, ease:Linear.easeIn});
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
			var tiles : Vector.<CourtTile> = new Vector.<CourtTile>();
			if(radius == 0){
				addTileToGroup(tiles, getTile(gridX, gridY));
			}else{
				for (var h : int = gridX - radius; h <= gridX + radius; h++) {
					addTileToGroup(tiles, getTile(h, gridY - radius));
					addTileToGroup(tiles, getTile(h, gridY + radius));
				}
				for (var v : int = gridY - radius + 1; v < gridY + radius; v++) {
					addTileToGroup(tiles, getTile(gridX - radius, v));
					addTileToGroup(tiles, getTile(gridX + radius, v));
				}
			}
			trace("CourtView.getTileRing(",tiles,")");
			return tiles;
		}

		private function addTileToGroup(tiles : Vector.<CourtTile>, tile : CourtTile) : void
		{
			if(tile)tiles.push(tile);
		}
		
		public function getTile(gridX : int, gridY : int) : CourtTile
		{
			if(gridX < 0 || gridX >= Layout.COURT_WIDTH || gridY < 0 || gridY >= Layout.COURT_HEIGHT) return null;
			trace("CourtView.getTile(",gridX, gridY,")");
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
		
		public function positionBall(data : ShotData) : void
		{
			_ball.x = data.gridX * Layout.TILE_WIDTH;
			_ball.y = data.gridY * Layout.TILE_HEIGHT;
			_bounce.x = data.bounceX * Layout.TILE_WIDTH;
			_bounce.y = data.bounceY * Layout.TILE_HEIGHT;
		}
		
		public function showTurn(turn : TurnData, callback : Function) : void
		{
			var player : CharacterView = _charactersMap[turn.playerData.id];
			TweenMax.killTweensOf(player);
			TweenMax.killTweensOf(_ball);
			if(turn.preMove) TweenMax.to(player, 1, {x:turn.preMove.gridX * Layout.TILE_WIDTH, y:turn.preMove.gridY * Layout.TILE_HEIGHT, delay : .5});
			if(turn.shot) TweenMax.to(_ball, .75, {x:turn.shot.gridX * Layout.TILE_WIDTH, y:turn.shot.gridY * Layout.TILE_HEIGHT, delay : 1.75});
			if(turn.postMove) TweenMax.to(player, 1, {x:turn.postMove.gridX * Layout.TILE_WIDTH, y:turn.postMove.gridY * Layout.TILE_HEIGHT, delay:2});
			TweenMax.delayedCall(3, callback);
			TweenMax.killTweensOf(_bounce);
			
			if(turn.preMove) TweenMax.to(player, 1, {x:turn.preMove.gridX * Layout.TILE_WIDTH, y:turn.preMove.gridY * Layout.TILE_HEIGHT, delay : .5, onComplete: playHitSound});
			
			TweenMax.to(_bounce, .75, {x:turn.shot.bounceX * Layout.TILE_WIDTH, y:turn.shot.bounceY * Layout.TILE_HEIGHT, delay : 1.75});
			TweenMax.to(_ball, .75, {x:turn.shot.gridX * Layout.TILE_WIDTH, y:turn.shot.gridY * Layout.TILE_HEIGHT, alpha: 1, delay : 1.75 + 0.75, onStart: playBounceSound});
			TweenMax.to(player, 1, {x:turn.postMove.gridX * Layout.TILE_WIDTH, y:turn.postMove.gridY * Layout.TILE_HEIGHT, delay:2 + 0.75, onComplete:callback});
		}
		
		private function playBounceSound() : void {
			_bounceSound.play(166);
		}
		
		private function playHitSound() : void {
			_hitSound.play(166);
		}

		public function get tiles() : Vector.<CourtTile>
		{
			return _tiles;
		}
		
		public function showAccuracyValues():void
		{
			for each (var tile : CourtTile in _tiles) {
				tile.accuracyHighlight.visible = true;
			}
		}
		
		public function hideAccuracyValues():void
		{
			for each (var tile : CourtTile in _tiles) {
				tile.accuracyHighlight.visible = false;
			}
		}
		
		private function onUpdate(event : Event) : void
		{
			updateEffects();
		}

		private function updateEffects() : void
		{
			if(_ball.x != _ball.xPrevious || _ball.y != _ball.yPrevious){
				var m : Matrix = new Matrix();
				m.translate(_ball.x, _ball.y);
				var c : ColorTransform = new ColorTransform();
				c.alphaMultiplier = .5;
				_effectsBMD.draw(_ball, m, c);
			}
			_effectsBMD.applyFilter(_effectsBMD, _effectsBMD.rect, new Point(), new BlurFilter(2,2));
			_ball.xPrevious = _ball.x;
			_ball.yPrevious = _ball.y;
		}

		public function get validServiceLeftTiles() : Vector.<CourtTile>
		{
			return _validServiceLeftTiles;
		}

		public function get validServiceRightTiles() : Vector.<CourtTile>
		{
			return _validServiceRightTiles;
		}

		public function get validCourtTiles() : Vector.<CourtTile>
		{
			return _validCourtTiles;
		}
	}
}
