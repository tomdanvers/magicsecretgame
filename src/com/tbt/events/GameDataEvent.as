package com.tbt.events
{
	import flash.events.Event;

	/**
	 * @author Tom Danvers - tom@tomdanvers.com
	 */
	public class GameDataEvent extends Event
	{
		public static const RESET : String = 'RESET';
		public function GameDataEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
