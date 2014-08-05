package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.KeyboardEvent;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.text.TextFieldAutoSize;
	
	/**	 
	 * @author  Bernardo
	 */
	public dynamic class Game extends Sprite
	{
		private var paddleUp:Boolean;
		private var paddleDown:Boolean;
		private var paddle:Paddle;
		private var paddleAI:Paddle;
		private var balls: Array;
		private var ball:Ball;
		private var fps:FPSBox;
		private var startText:TextField;
		private var gameOverText:TextField
		private var retryText:TextField
		private var scoreText:TextField
		private var score:Number = 0;
		private var ballColors:Array = [ 0xFF0000, 0xFFFF00 ];
		private var clock: Timer;
		
		public function Game() : void
		{
			this.graphics.lineStyle(2, 0x000000);
			this.graphics.drawRect(0, 0, 300, 300);
			
			createStartScreen();
		}
		
		private function createStartScreen():void
		{
			startText = new TextField();
			startText.autoSize = TextFieldAutoSize.CENTER;
			startText.text = 'PRESS S TO START';
			startText.textColor = 0x666666;
			startText.x = stage.stageWidth / 2 - startText.width/2;
			startText.y = stage.stageHeight / 2 - startText.height/2;
			addChild(startText);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, startListener);
		}
		
		private function removeStartScreen():void
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, startListener);
			removeChild(startText);
		}
		
		private function startListener(e:KeyboardEvent):void
		{
			if (e.keyCode == 83)
			{
				removeStartScreen();
				initGame();
			}
		}
		
		private function updateScore():void
		{
			scoreText.text = 'Score: ' + score;
		}
		
		private function initGame():void
		{
			fps = new FPSBox();
			addChild(fps);
			
			scoreText = new TextField();
			scoreText.x = 250;
			scoreText.text = 'Score: 0';
			addChild(scoreText);
			
			ball = new Ball(0x000000, Math.PI / 2, 10);
			ball.x = 150;
			ball.y = 150;
			addChild(ball);
			
			balls = new Array();
			
			paddle = new Paddle();
			paddle.x = 20;
			paddle.y = 120;
			addChild(paddle);
			
			paddleAI = new Paddle(15);
			paddleAI.x = 280;
			paddleAI.y = 120;
			addChild(paddleAI);
			
			clock = new Timer(50);
			clock.addEventListener(TimerEvent.TIMER, timerEvent);
			clock.start();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);
			stage.addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		private function timerEvent(e:TimerEvent):void
		{
			paddleAI.moveTo(ball.y);
		}
		
		private function endGame():void
		{
			score = 0;
			paddleDown = false;
			paddleUp = false;
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpListener);
			stage.removeEventListener(Event.ENTER_FRAME, enterFrame);
			removeBalls();
			removeChild(ball);
			removeChild(paddle);
			removeChild(fps);
			removeChild(scoreText);
		}
		
		private function removeBalls():void
		{
			for each(var extraBall:Ball in balls)
			{
				removeChild(extraBall);
			}
		}
		
		private function gameOver():void
		{
			endGame();
			createRetryScreen();
		}
		
		private function createRetryScreen():void
		{
			gameOverText = new TextField();
			gameOverText.autoSize = TextFieldAutoSize.CENTER;
			gameOverText.text = 'FAIL';
			gameOverText.textColor = 0x666666;
			gameOverText.x = stage.stageWidth / 2 - gameOverText.width/2;
			gameOverText.y = stage.stageHeight / 3 - gameOverText.height/2;
			addChild(gameOverText);
			
			retryText = new TextField();
			retryText.autoSize = TextFieldAutoSize.CENTER;
			retryText.text = 'PRESS R TO RETRY';
			retryText.textColor = 0x666666;
			retryText.x = stage.stageWidth / 2 - retryText.width/2;
			retryText.y = stage.stageHeight / 2 - retryText.height/2;
			addChild(retryText);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, retryListener);
		}
		
		private function removeRetryScreen():void
		{
			removeChild(gameOverText);
			removeChild(retryText);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, retryListener);
		}
		
		private function retryListener(e:KeyboardEvent):void
		{
			if (e.keyCode == 82)
			{
				removeRetryScreen();
				initGame();
			}
		}
				
		private function enterFrame(e:Event):void
		{	
			if (paddleUp)
			{
				paddle.moveUp();
			}
			if (paddleDown)
			{
				paddle.moveDown();
			}
			for each (var extraBall:Ball in balls)
			{
				if (extraBall.hitTestObject(ball))
				{
					scorePoint();
					extraBall.horizontalHit();
					extraBall.verticalHit();
					ball.verticalHit();
					ball.horizontalHit();
				}
				if (extraBall.hitTestObject(paddle))
				{
					scorePoint();
					extraBall.paddleHit(paddle.getCenter(), paddle.height);
				}
				if (extraBall.x >= stage.stageWidth)
				{
					extraBall.horizontalHit();
				}
				if (extraBall.y >= stage.stageHeight || extraBall.y <= 0)
				{
					extraBall.verticalHit();
				}
				if (extraBall.x <= 0)
				{
					gameOver();
				}
				extraBall.update();	
			}
			if (ball.hitTestObject(paddle))
			{
				scorePoint();
				ball.paddleHit(paddle.getCenter(), paddle.height);
			}
			if (ball.hitTestObject(paddleAI))
			{
				//scorePoint();
				ball.paddleHit(paddleAI.getCenter(), paddleAI.height);
			}
			if (ball.x >= stage.stageWidth)
			{
				ball.horizontalHit();
			}
			if (ball.y >= stage.stageHeight || ball.y <= 0)
			{
				ball.verticalHit();
			}
			if (ball.x <= 0)
			{
				gameOver();
			}
			ball.update();
			updateScore();
		}
		
		private function updateBallPostion(ball:Ball):void
		{

		}
		
		private function addBall():void
		{
			//var newBall:Ball = new Ball(ballColors[0], Math.random() * 360 * Math.PI / 180, Math.random() * 20);
			var newBall:Ball = new Ball(ballColors[0], Math.random() * 360 * Math.PI / 180, 5);
			newBall.x = 150;
			newBall.y = 150;
			this.addChild(newBall);
			balls.push(newBall);
		}
		
		private function scorePoint():void
		{
			score += 1;
			
			if (score > 0 && score % 5 == 0)
			{
				//addBall();
			}
		}
		
		private function keyDownListener(e:KeyboardEvent):void
		{
			if (e.keyCode == 87)
			{
				paddleUp = true;
			}
			if (e.keyCode == 83)
			{
				paddleDown = true;
			}
		}	
		
		private function keyUpListener(e:KeyboardEvent):void
		{
			if (e.keyCode == 87)
			{
				paddleUp = false;
			}
			if (e.keyCode == 83)
			{
				paddleDown = false;
			}
		}
	}
}