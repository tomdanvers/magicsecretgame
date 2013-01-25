package com.tbt.view
{
	import com.tbt.constants.Layout;

	import flash.display.Sprite;

	/**
	 * @author Tom Danvers - tom@tomdanvers.com
	 */
	public class BallView extends Sprite
	{
		private var _xPrevious : Number = 0;
		private var _yPrevious : Number = 0;
		public function BallView()
		{
			draw(color);
			
			mouseEnabled = mouseChildren = false;
		}
		
		protected function draw(colour : uint) : void
		{
			graphics.clear();
			
			graphics.beginFill(colour, 0);
			graphics.drawRect(0, 0, Layout.TILE_WIDTH, Layout.TILE_HEIGHT);
			graphics.endFill();
			
			graphics.beginFill(colour);
			graphics.lineStyle(1,0xFFFFFF);
			graphics.drawCircle(Layout.TILE_WIDTH*.5, Layout.TILE_HEIGHT*.5, Math.min(Layout.TILE_WIDTH*.5, Layout.TILE_HEIGHT*.5)*.3);
			graphics.endFill();
		}

		public function get xPrevious() : Number
		{
			return _xPrevious;
		}

		public function set xPrevious(xPrevious : Number) : void
		{
			_xPrevious = xPrevious;
		}

		public function get yPrevious() : Number
		{
			return _yPrevious;
		}

		public function set yPrevious(yPrevious : Number) : void
		{
			_yPrevious = yPrevious;
		}
		
	}
}
