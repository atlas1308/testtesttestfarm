package tzh.core
{
	import flash.events.Event;

	public class TooltipEvent extends Event
	{
		
		public static const SHOW_TOOLTIP:String = "showTooltip";
		
		public static const HIDE_TOOLTIP:String = "hideTooltip";
		
		public function TooltipEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			return new TooltipEvent(type, bubbles, cancelable);
		}
	}
}