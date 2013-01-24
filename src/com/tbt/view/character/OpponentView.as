package com.tbt.view.character
{
	import com.tbt.constants.Colours;

	/**
	 * @author Tom Danvers - tom@tomdanvers.com
	 */
	public class OpponentView extends CharacterView
	{
		public function OpponentView(id : String)
		{
			super(id);
			
			draw(Colours.OPPONENT);
		}
	}
}
