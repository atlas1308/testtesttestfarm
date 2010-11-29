package tzh.core
{	
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	public class GlowTween
	{
		private var target:InteractiveObject;
		private var color:uint;
		private var toggle:Boolean;
		private var blur:Number;
		
		public var step:int = 4;
		public function GlowTween(target:InteractiveObject, color:uint = 0xFFFFFF)
		{
			this.target = target;
			this.color = color;
			toggle = true;
			this.blur = 10;
			
		}
		
		public function remove():void
		{
			if(target){
				target.removeEventListener(Event.ENTER_FRAME, blinkHandler);
				target.filters = null;
				target = null;
			}
		}		
		
		public function start():void
		{
			target.addEventListener(Event.ENTER_FRAME, blinkHandler, false, 0, true);				
		}
		
		private function stop(evt:MouseEvent):void
		{
			target.removeEventListener(Event.ENTER_FRAME, blinkHandler);			
			target.filters = null;
		}
		
		private function blinkHandler(evt:Event):void
		{
			if (blur >= 20) toggle = false;
			else if (blur <= 2) toggle = true;
			toggle ? blur+=step : blur-=step;			
			var glow:GlowFilter = new GlowFilter(color, 1, blur, blur, 2, 2);
			target.filters = [glow];	
		}
	}	
}