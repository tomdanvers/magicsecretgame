package com.tbt.view.tiles
{
	import com.tbt.constants.Colours;
	import com.tbt.constants.Layout;
	import com.tbt.constants.TileTypes;
	import com.tbt.utils.TextBitmap;
	import com.tbt.utils.TextFormats;

	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author Tom Danvers - tom@tomdanvers.com
	 */
	public class CourtTile extends Sprite
	{
		public var gridX : int;
		public var gridY : int;
		private var _label : TextBitmap;
		private var _value : int;
		private var _accuracyValue : Number;
		private var _accuracyHighlight : Sprite;
		private var _type : String;

		public function CourtTile(gridX : int, gridY : int)
		{
			this.gridY = gridY;
			this.gridX = gridX;
			
			addChild(_accuracyHighlight = new Sprite());
			drawTile(_accuracyHighlight.graphics, 0x00cbe1);
			_accuracyHighlight.alpha = 0;
			_accuracyHighlight.visible = false;
			
			addChild(_label = new TextBitmap(TextFormats.TILE_LABEL));
			_label.alpha = .25;
			
			addEventListener(MouseEvent.MOUSE_OVER, onOver);
			addEventListener(MouseEvent.MOUSE_OUT, onOut);
		}

		private function onOver(event : MouseEvent) : void
		{
			_label.alpha = 1;
		}

		private function onOut(event : MouseEvent) : void
		{
			_label.alpha = .25;
		}

		public function set type(type : String) : void
		{
			_type = type;
			switch(type){
				case TileTypes.OUT:
					drawTile(this.graphics, Colours.TILE_OUT);
					break;
				case TileTypes.SERVICE_LEFT:
					drawTile(this.graphics, Colours.TILE_SERVICE_LEFT);
					break;
				case TileTypes.SERVICE_RIGHT:
					drawTile(this.graphics, Colours.TILE_SERVICE_RIGHT);
					break;
				case TileTypes.COURT:
					drawTile(this.graphics, Colours.TILE_COURT);
					break;
				case TileTypes.ALLEY:
					drawTile(this.graphics, Colours.TILE_ALLEY);
					break;
				default:
					drawTile(this.graphics, 0xFF0000);
			}
		}

		private function drawTile(graphics : Graphics, colour : uint) : void
		{
			graphics.lineStyle(1, 0xFFFFFF,.2, true);
			graphics.beginFill(colour);
			graphics.drawRect(0, 0, Layout.TILE_WIDTH, Layout.TILE_HEIGHT);
			graphics.endFill();
		}
		
		public function set label(label : String) : void
		{
			if(label){
				_label.text = label;
				_label.x = Layout.TILE_WIDTH - _label.width >> 1;
				_label.y = Layout.TILE_HEIGHT - _label.height >> 1;
				_label.visible = true;
			}else{
				_label.visible = false;
			}
		}
		
		override public function toString() : String
		{
			return '[tile : ' + gridX + '/' + gridY + ']';
		}

		public function get value() : int
		{
			return _value;
		}

		public function set value(value : int) : void
		{
			_value = value;
			label = String(value);
		}

		public function get accuracyValue() : Number
		{
			return _accuracyValue;
		}

		public function set accuracyValue(accuracyValue : Number) : void
		{
			_accuracyValue = accuracyValue;
			_accuracyHighlight.alpha = _accuracyValue;
		}

		public function get accuracyHighlight() : Sprite
		{
			return _accuracyHighlight;
		}

		public function get type() : String
		{
			return _type;
		}
	}
}
