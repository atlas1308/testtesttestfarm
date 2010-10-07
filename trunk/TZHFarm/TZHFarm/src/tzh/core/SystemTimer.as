package tzh.core
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	public class SystemTimer
	{
		private var delay:Number = 25;
		private var prevTime:Number = 0;
		public function SystemTimer()
		{
		}
		
		private var started:Boolean;// 一个标记,防止多次调用
		
		private function start():void {
			if(!started){
				started = true;
				var timer:Timer = new Timer(delay);
				timer.addEventListener(TimerEvent.TIMER,timerHandler);
				timer.start();
				prevTime = getTimer();
			}
		}
		
		private var _serverTime:Number = 0;
		
		public function set serverTime(value:Number):void {
			this._serverTime = value;
			this.start();
		}
		
		private function timerHandler(evt:TimerEvent):void {
			var nextTime:Number = getTimer();
			var diffTime:Number = (nextTime - prevTime) / 1000;
			prevTime = nextTime;
			this._serverTime += diffTime;
		}
		
		public function get serverTime():Number {
			return this._serverTime;
		}
		
		private static var instance:SystemTimer;
		
		public static function getInstance():SystemTimer {
			if(instance == null){
				instance = new SystemTimer();
			}
			return instance;
		}	
	}
}