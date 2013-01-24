package com.tbt.view
{
	import com.tbt.constants.Layout;
	import flash.display.Sprite;

	/**
	 * @author Tom Danvers - tom@tomdanvers.com
	 */
	public class WaitingView extends Sprite
	{
		public function WaitingView()
		{
			graphics.beginFill(0x000000, .75);
			graphics.drawRect(0, 0, Layout.VIEW_WIDTH, Layout.VIEW_HEIGHT);
			graphics.endFill();
		}
	}
}
