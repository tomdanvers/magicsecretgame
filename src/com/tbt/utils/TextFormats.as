package com.tbt.utils
{
	import flash.text.TextFormat;
	/**
	 * @author Tom Danvers - tom@tomdanvers.com
	 */
	public class TextFormats
	{
		[Embed(source="/../assets/fonts/ARIALBD.TTF", fontName="Arial", mimeType="application/x-font",
			advancedAntiAliasing="true", fontWeight="normal", fontStyle="normal",
			unicodeRange="U+0020-U+007e", embedAsCFF="true")]
		private var Arial : Class;
		
		public static const GAME_LABEL : TextFormat = new TextFormat('Arial', 20, 0xFFFFFF);
		public static const AP_LABEL : TextFormat = new TextFormat('Arial', 16, 0xFFFFFF);
		public static const TILE_LABEL : TextFormat = new TextFormat('Arial', 10, 0xFFFFFF);
	}
}
