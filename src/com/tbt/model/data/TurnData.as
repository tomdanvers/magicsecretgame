package com.tbt.model.data
{
	/**
	 * @author Tom Danvers - tom@tomdanvers.com
	 */
	public class TurnData
	{
		public var playerId : String;
		public var preMove : MoveData;
		public var shot : ShotData;
		public var postMove : MoveData;

		public function TurnData(playerId : String) : void
		{
			this.playerId = playerId;
		}
	}
}
