package tzh.core
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import flash.utils.getTimer;
	
	/* import flash.utils.getTimer; */
	public class TZHTimer
	{
		private var closure:Function;
		
		private var delay:Number;
		
		private var args:Object;
		
		public static const STEP:int = 5;
		
		public function TZHTimer(closure:Function, delay:Number, ...parameters) {
			this.closure = closure;
			this.delay = delay;
			this.args = parameters;
		}
		
		private var timer:Timer;
		
		private var lastTime:Number;
		
		public function start():void {
			timer = new Timer(STEP);
			timer.addEventListener(TimerEvent.TIMER,timeHandler);
			lastTime = getTimer();
			timer.start();
		}
		
		public function destory():void {
			if(timer){
				timer.removeEventListener(TimerEvent.TIMER,timeHandler);
				timer.stop();
				timer = null;
			}
		}
		
		private function timeHandler(event:TimerEvent):void {
			var diff:Number = getTimer() - lastTime;
			if(diff >= this.delay){
				trace("diff " + diff);
				this.closure.apply(null);
				this.destory();
			}
		}
	}
}