package com.tbt
{
	import com.tbt.constants.CourtSides;
	import com.tbt.constants.Layout;
	import com.tbt.constants.PlayerIds;
	import com.tbt.model.GameData;
	import com.tbt.model.PlayerData;
	import com.tbt.view.GameView;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	/**
	 * @author Tom Danvers - tom@tomdanvers.com
	 */
	[SWF(backgroundColor="#000000", frameRate="60", width="800", height="600")]
	public class Main extends Sprite
	{
		public function Main()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			var player1 : PlayerData = new PlayerData(PlayerIds.ONE);
			var player2 : PlayerData = new PlayerData(PlayerIds.TWO);
			
			player1.opponent = player2;
			player2.opponent = player1;
			
			player1.courtSide = CourtSides.TOP;
			player2.courtSide = CourtSides.BOTTOM;
			
			var game : GameData = new GameData();
			game.init(player1, player2);
			
			var viewPlayer1 : GameView = new GameView(game, player1);
			addChild(viewPlayer1);
			
			var viewPlayer2 : GameView = new GameView(game, player2);
			viewPlayer2.x = Layout.VIEW_WIDTH;
			addChild(viewPlayer2);
			
			game.reset();
		}
	}
}
