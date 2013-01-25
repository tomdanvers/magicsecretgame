package com.tbt.view.character
{
	import com.tbt.model.PlayerData;
	import com.tbt.constants.Layout;
	import flash.display.Sprite;

	/**
	 * @author Tom Danvers - tom@tomdanvers.com
	 */
	public class CharacterView extends Sprite
	{
		public var data : PlayerData;
		
		public function CharacterView(data : PlayerData) 
		{
			this.data = data;
		}
		
		protected function draw(colour : uint) : void
		{
			graphics.clear();
			
			graphics.beginFill(colour, .1);
			graphics.drawRect(0, 0, Layout.TILE_WIDTH, Layout.TILE_HEIGHT);
			graphics.endFill();
			
			graphics.beginFill(colour);
			graphics.drawCircle(Layout.TILE_WIDTH*.5, Layout.TILE_HEIGHT*.5, Math.min(Layout.TILE_WIDTH*.5, Layout.TILE_HEIGHT*.5)*.75);
			graphics.endFill();
			
			mouseEnabled = mouseChildren = false;
		}
	}
}
