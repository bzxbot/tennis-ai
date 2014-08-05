package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	/**
	 * ...
	 * @author  Bernardo
	 */
	public class Paddle extends Sprite
	{
		private var up:Boolean;
		private var down:Boolean;
		private var yIncrement:int;
		
		public function Paddle(yIncrement:int = 10)
		{
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, 10, 60);
			graphics.endFill();
			
			this.yIncrement = yIncrement;
		}
		
		public function moveDown():void
		{
			if (this.y < stage.stageHeight - 60)
			{
				this.y += yIncrement;
			}
		}
		
		public function moveUp():void
		{
			if (this.y != 0)
			{
				this.y -= yIncrement;
			}
		}
				
		public function getCenter():int
		{
			return this.y + 30;
		}
		
		public function moveTo(yPosition:int):void
		{
			if (this.y + 30 > yPosition + 30)
			{
				moveUp();
			}
			else if (this.y + 30 < yPosition - 30)
			{
				moveDown();
			}
		}
	}	
}