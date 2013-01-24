package com.tbt.view
{
	import com.tbt.constants.Layout;
	import flash.display.JointStyle;
	import flash.display.CapsStyle;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;

	/**
	 * @author Tom Danvers - tom@tomdanvers.com
	 */
	public class CourtLines extends Sprite
	{
		public function CourtLines()
		{
			graphics.lineStyle(2,0xFFFFFF, 1, true, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.MITER);
			
			drawBox(3,5,10,20);//Outline
			
			drawBox(3,5,1,20);//Alley
			drawBox(12,5,1,20);//Alley
			
			drawBox(4,10,4,5);//Service
			drawBox(8,10,4,5);//Service
			
			drawBox(4,15,4,5);//Service
			drawBox(8,15,4,5);//Service
			
		}

		private function drawBox(x : int, y : int, w : int, h : int) : void
		{
			graphics.drawRect(x*Layout.TILE_WIDTH, y*Layout.TILE_HEIGHT, w*Layout.TILE_WIDTH, h*Layout.TILE_HEIGHT);
		}
	}
}
