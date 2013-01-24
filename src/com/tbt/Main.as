package com.tbt
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import com.tbt.model.BallData;
	import com.tbt.constants.Layout;
	import com.tbt.constants.PlayerIds;
	import com.tbt.view.GameView;
	import com.tbt.model.GameData;
	import com.tbt.model.PlayerData;
	import flash.display.Sprite;

	/**
	 * @author Tom Danvers - tom@tomdanvers.com
	 */
	[SWF(backgroundColor="#000000", frameRate="31", width="800", height="600")]
	public class Main extends Sprite
	{
		public function Main()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			var player1 : PlayerData = new PlayerData(PlayerIds.ONE, 7,25);
			var player2 : PlayerData = new PlayerData(PlayerIds.TWO, 8,4);
			var ball : BallData = new BallData(7,24);
			
			var game : GameData = new GameData();
			game.init(player1, player2, ball);
			
			var viewPlayer1 : GameView = new GameView(game, PlayerIds.ONE, PlayerIds.TWO, false);
			addChild(viewPlayer1);
			
			var viewPlayer2 : GameView = new GameView(game, PlayerIds.TWO, PlayerIds.ONE, true);
			viewPlayer2.x = Layout.VIEW_WIDTH;
			addChild(viewPlayer2);
		}
	}
}
