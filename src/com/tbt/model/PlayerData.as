package com.tbt.model {
	import com.tbt.model.data.ShotData;
	/**
	 * @author Tom Danvers - tom@tomdanvers.com
	 */
	public class PlayerData
	{
		public var id : String;
		public var gridX : int;
		public var gridY : int;
		public var ap : int;
		public var opponent : PlayerData;
		public var courtSide : String;
		
		public function PlayerData(id : String, gridX : int = 0, gridY : int = 0) 
		{
			this.id = id;
			this.gridY = gridY;
			this.gridX = gridX;
			this.ap = 50;
		}

		public static function getInitialPosition() : ShotData {
//            var player1 : PlayerData = new PlayerData(PlayerIds.ONE, 7,25);
//            var player2 : PlayerData = new PlayerData(PlayerIds.TWO, 8,4);
			return new ShotData(7, 25, 7, 25, 0);
		}
	}
}
