package com.tbt.utils
{
	import com.tbt.constants.Layout;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	/**
	 * @author Tom Danvers - tom@tomdanvers.com
	 */
	public class DataMaps
	{
		[Embed(source="/../assets/datamaps/accuracy.png")]
		private static var ACCURACY_MAP_SRC : Class;
		private static var ACCURACY_MAP : BitmapData;
		
		public static function getAccuracyValue(gridX : uint, gridY : uint) : Number
		{
			if(ACCURACY_MAP == null){
				ACCURACY_MAP = Bitmap(new ACCURACY_MAP_SRC()).bitmapData;
			}
			return getValueFromMap(gridX, gridY, ACCURACY_MAP);
		}

		private static function getValueFromMap(x : uint, y : uint, map : BitmapData) : Number
		{
			var colour : uint = map.getPixel32(x * Layout.DATA_MAP_SCALE + Layout.DATA_MAP_SCALE*.5, y * Layout.DATA_MAP_SCALE + Layout.DATA_MAP_SCALE*.5);
			var r : uint = colour >> 16 & 0xFF;
			return r/255;
		}
	}
}
