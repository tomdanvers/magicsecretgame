package com.tbt.view.character
{
	import com.tbt.constants.Colours;
	import com.tbt.model.PlayerData;

	/**
	 * @author Tom Danvers - tom@tomdanvers.com
	 */
	public class PlayerView extends CharacterView
	{
		public function PlayerView(data : PlayerData)
		{
			super(data);
			
			draw(Colours.PLAYER);
		}
	}
}
