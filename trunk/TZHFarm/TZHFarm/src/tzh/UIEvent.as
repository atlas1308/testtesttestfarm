package tzh
{
	import flash.events.Event;

	public class UIEvent extends Event
	{
		public static const END_EFFECT_POST_FEED:String = "end_effect_post_feed";
		
		public function UIEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		
		override public function clone():Event {
			return new UIEvent(type, bubbles, cancelable);
		}
	}
}