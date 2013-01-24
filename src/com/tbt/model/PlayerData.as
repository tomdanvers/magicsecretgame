package com.tbt.model
{
	/**
	 * @author Tom Danvers - tom@tomdanvers.com
	 */
	public class PlayerData
	{
		public var id : String;
		public var gridX : int;
		public var gridY : int;
		public var ap : int;
		
		public function PlayerData(id : String, gridX : int = 0, gridY : int = 0) 
		{
			this.id = id;
			this.gridY = gridY;
			this.gridX = gridX;
			this.ap = 50;
		}
	}
}
