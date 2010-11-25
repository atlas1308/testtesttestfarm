package tzh
{
	import flash.events.Event;

	public class UIEvent extends Event
	{
		public static const END_EFFECT_POST_FEED:String = "end_effect_post_feed";
		
		public static const HIDE_OVERLAY:String = "hideOverlay";
		
		public static const SHOW_OVERLAY:String = "showOverlay";
		
		public static const ADD_MESSAGE:String = "addMessage";
		
		public static const SHOW_NEWS_PANEL:String = "showNewsPanel";
		
		public static const BUY_ITEM:String = "buyItem";
		
		public static const CLOSE_EVENT:String = "closeEvent";
		
		public function UIEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		
		override public function clone():Event {
			return new UIEvent(type, bubbles, cancelable);
		}
	}
}