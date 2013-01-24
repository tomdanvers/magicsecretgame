package com.tbt.view.ui
{
	import com.tbt.utils.TextFormats;
	import com.tbt.utils.TextBitmap;
	import flash.events.MouseEvent;
	import flash.display.Sprite;

	/**
	 * @author Tom Danvers - tom@tomdanvers.com
	 */
	public class ValueSlider extends Sprite
	{
		private static var WIDTH : int = 40;
		private static var HEIGHT : int = 40;
		
		private var _value : int;
		private var _label : TextBitmap;
		private var _text : String;
		private var _valueMin : int;
		private var _valueMax : int;
		
		public function ValueSlider(text : String, valueMin : int, valueMax : int)
		{
			_text = text;

			addChild(_label = new TextBitmap(TextFormats.AP_LABEL));

			_valueMin = valueMin;
			_valueMax = valueMax;
			value = Math.round(valueMin + (valueMax-valueMin)*.5);
			
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}

		private function onMouseWheel(event : MouseEvent) : void
		{
			if(event.delta > 0){
				value += 1;
			}else if(event.delta < 0){
				value -= 1;
			}
		}

		public function get value() : int
		{
			return _value;
		}

		public function set value(value : int) : void
		{
			if(value < _valueMin){
				value = _valueMin;
			}else if(value > _valueMax){
				value = _valueMax;
			}
			_value = value;
			
			_label.text = _text + ': ' + value;
		}
	}
}
