package tzh.core
{
	public class Constant
	{
		public function Constant()
		{
		}
		
		public static const BACKGROUND_KEY:String = "background_key";
		
		public static const SHOW_TOOLTIP:String = "showTooltip";
		
		public static const HIDE_TOOLTIP:String = "hideTooltip";
		
		public static const FERTILIZER_CURSOR_PATH:String = "images/fertilizer_cur.png";
		
		/**
         * 发送向好友要礼物的请求 
         */ 
        public static function showAskForGiftsHandler():void {
        	var manager:JSDataManager = JSDataManager.getInstance();
        	var username:String = "";
        	if(manager.userInfo && manager.userInfo.name){
				username = manager.userInfo.name;
        	}
        	manager.postFeed(FeedData.getRequestGiftsMessage(username));
        }
	}
}