package tzh.core
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class SystemTimer
	{
		private var delay:Number = 250;
		private var prevTime:Number = 0;
		public function SystemTimer()
		{
		}
		
		private var started:Boolean;// 一个标记,防止多次调用
		
		public function start():void {
			if(!started){
				started = true;
				var timer:Timer = new Timer(delay);
				timer.addEventListener(TimerEvent.TIMER,timerHandler);
				timer.start();
				prevTime = new Date().getTime();
			}
		}
		
		private function timerHandler(evt:TimerEvent):void {
			var nextTime:Number = new Date().getTime();
			var diffTime:Number = nextTime - prevTime;
			var maxDelay:Number = delay * 2;
			if(diffTime > maxDelay){
				trace("please update game , you update your clock timer");
			}else {
				prevTime = nextTime;
			}
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