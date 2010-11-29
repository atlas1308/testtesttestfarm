package tzh.core
{
	import flash.utils.Dictionary;
	
	
	/**
	 * 用一个更精确的时间来实现这个
	 */ 
	public class TZHTimeout
	{
		public function TZHTimeout()
		{
		}
		
		private static var map:Dictionary = new Dictionary(true);
		
		private static var ID:uint = 0;
		public static function setTimeout(closure:Function, delay:Number, ...parameters):uint{
			var tzhTimer:TZHTimer = new TZHTimer(closure,delay,parameters);
			map[ID++] = tzhTimer;
			tzhTimer.start();
			return ID;
		}
		
		public static function clearTimeout(id:uint):void{
			var tzhTimer:TZHTimer = map[id];
			tzhTimer.destory();
			delete map[id];
		}
	}
}