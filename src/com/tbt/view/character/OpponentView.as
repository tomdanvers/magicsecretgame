package com.tbt.view.character
{
	import com.tbt.constants.Colours;
	import com.tbt.model.PlayerData;

	/**
	 * @author Tom Danvers - tom@tomdanvers.com
	 */
	public class OpponentView extends CharacterView
	{
		public function OpponentView(data : PlayerData)
		{
			super(data);
			
			draw(Colours.OPPONENT);
		}
	}
}
