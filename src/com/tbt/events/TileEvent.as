package com.tbt.events
{
	import com.tbt.view.tiles.CourtTile;
	import flash.events.Event;

	/**
	 * @author Tom Danvers - tom@tomdanvers.com
	 */
	public class TileEvent extends Event
	{
		public static const CLICK : String = "CLICK";
		public var tile : CourtTile;
		public function TileEvent(type : String, tile : CourtTile, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
			
			this.tile = tile;
		}
	}
}
