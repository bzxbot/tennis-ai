package  
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author  Bernardo
	 */
	public class Ball extends Sprite
	{
		private var angle: int;
		public var speed: Number;
		
		public var xIncrement: int = 1;
		public var yIncrement: int = 1;
		
		public function Ball(color:uint, angle: int, speed: Number)
		{
			graphics.beginFill(color);
			graphics.drawCircle(0, 0, 5);
			graphics.endFill();
			
			this.angle = angle
			this.speed = speed;

			xIncrement += Math.sin(this.angle) * this.speed;
			yIncrement += Math.cos(this.angle) * this.speed;
		}
		
		public function update():void
		{
			this.x += xIncrement;
			this.y += yIncrement;
		}
		
		public function increaseSpeed():void
		{
			speed += 0;
		}
		
		public function decreaseSpeed():void
		{
			speed -= 0;
		}
		
		public function paddleHit(paddleCenter:int, paddleHeight:int):void
		{
			var adjustValue:Number = this.speed / paddleHeight * Math.sqrt(2);
			this.yIncrement = (this.y - paddleCenter) * adjustValue;
			this.yIncrement = yIncrement == 0 ? 1 : yIncrement;
			var xIncrement:Number = Math.sqrt(Math.pow(this.speed, 2) -  Math.pow(this.yIncrement, 2));
			this.xIncrement = this.xIncrement < 0 ? xIncrement : -xIncrement;
			trace(this.yIncrement);
			trace(this.xIncrement);
		}
		
		public function horizontalHit():void
		{
			xIncrement = -xIncrement;
		}
		
		public function verticalHit():void
		{
			yIncrement = -yIncrement;
		}
	}
	
}