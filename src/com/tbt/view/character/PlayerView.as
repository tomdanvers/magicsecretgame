package com.tbt.view.character
{
	import com.tbt.constants.Colours;

	/**
	 * @author Tom Danvers - tom@tomdanvers.com
	 */
	public class PlayerView extends CharacterView
	{
		public function PlayerView(id : String)
		{
			super(id);
			
			draw(Colours.PLAYER);
		}
	}
}
