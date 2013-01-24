package com.tbt.model.data
{
	/**
	 * @author Tom Danvers - tom@tomdanvers.com
	 */
	public class MoveData
	{
		public var gridX : int;
		public var gridY : int;
		public var cost : int;

		public function MoveData(gridX : int, gridY : int, cost : int) 
		{
			this.gridX = gridX;
			this.gridY = gridY;
			this.cost = cost;
		}
	}
}
