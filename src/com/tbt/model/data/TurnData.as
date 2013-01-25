package com.tbt.model.data
{
	import com.tbt.model.PlayerData;
	/**
	 * @author Tom Danvers - tom@tomdanvers.com
	 */
	public class TurnData
	{
		public var playerData : PlayerData;
		public var preMove : MoveData;
		public var shot : ShotData;
		public var postMove : MoveData;
		public var playerLostPoint : Boolean = false;

		public function TurnData(playerData : PlayerData) : void
		{
			this.playerData = playerData;
		}
	}
}
