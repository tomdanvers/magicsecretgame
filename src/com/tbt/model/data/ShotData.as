package com.tbt.model.data
{
	/**
	 * @author Tom Danvers - tom@tomdanvers.com
	 */
	public class ShotData
	{
		public var bounceX : int;
		public var bounceY : int;
		public var gridX : int;
		public var gridY : int;
		
		public var cost : int;

		public function ShotData(bounceX : int, bounceY : int, gridX : int, gridY : int, cost : int) 
		{
			this.gridY = gridY;
			this.gridX = gridX;
			this.bounceX = bounceX;
			this.bounceY = bounceY;
			this.cost = cost;
		}
	}
}
