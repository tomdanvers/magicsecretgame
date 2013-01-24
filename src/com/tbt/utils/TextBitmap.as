package com.tbt.utils
{
	import flash.text.Font;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author Tom Danvers - tom@tomdanvers.com
	 */
	public class TextBitmap extends Bitmap 
	{
		private static const DEBUG : Boolean = false;
		private static const CHECK_GLYPHS : Boolean = true;
		
		private var _trim : Boolean;

		private var _textField : TextField;
		
		public function TextBitmap(textFormat : TextFormat, trim : Boolean = true) 
		{
			_trim = trim;
			
			_textField = new TextField();
			_textField.defaultTextFormat = textFormat;
			_textField.embedFonts = true;
			_textField.antiAliasType = AntiAliasType.ADVANCED;
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.multiline = false;
		}
		
		public function get text() : String
		{
			return _textField.text;
		}
		
		public function set text(text : String) : void
		{
			_textField.text = text;
			
			invalidate();
		}
		
		public function set htmlText(htmlText : String) : void
		{
			_textField.htmlText = htmlText;
			
			invalidate();
		}
				
		public function invalidate() : void 
		{
			if(_textField.width == 0 || _textField.height == 0) return;
			
			if(CHECK_GLYPHS) checkGlyphs(); 
			
			if(_trim){
				var boundsBMD : BitmapData = new BitmapData(_textField.width, _textField.height, true, 0x00FFFFFF);
				boundsBMD.draw(_textField, null, null, null, null, true);
			}

			var bounds : Rectangle = _trim ? boundsBMD.getColorBoundsRect(0xFFFFFFFF, 0x000000, false) : new Rectangle(0,0,_textField.width, _textField.height);
			
			if(bounds.width == 0 || bounds.height == 0) return;
			
			var m : Matrix = new Matrix();
			if(_trim) m.translate(-bounds.x, -bounds.y);
			bitmapData = new BitmapData(bounds.width, bounds.height, true, DEBUG ? 0x22FF0000 : 0x00000000);
			bitmapData.draw(_textField, m, null, null, null, true);
		}

		private function checkGlyphs() : void
		{
			var embeddedFonts : Array = Font.enumerateFonts(false);

			var font : Font;
			for(var i : int = 0;i < embeddedFonts.length;i++) {
				font = embeddedFonts[i];
				if(font.fontName == _textField.defaultTextFormat.font){
					if(!font.hasGlyphs(_textField.text)) trace("TextBitmap.invalidate(FONT '"+font.fontName+"' IS MISSING GLYPHS: "+_textField.text+" )");
				}
			}
		}

		public function get textField() : TextField 
		{
			return _textField;
		}
	}
}
