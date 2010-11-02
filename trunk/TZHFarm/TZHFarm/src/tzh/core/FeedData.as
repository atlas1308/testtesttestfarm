package tzh.core
{
	import mx.resources.ResourceManager;
	
	/**
	 * 发送Feed或者Notice时的一些数据,都在这里处理
	 */ 
	public class FeedData
	{
		public function FeedData()
		{
		}
		
		
		public static function getUpgradeLevelMessage(username:String,level:int):Object {
			var obj:Object = {};
			obj.body = ResourceManager.getInstance().getString("message","user_upgrade_level_post_message",[username,level]);
			obj.src = Config.getConfig("host") + "feed/feed_upgrade.png";
			return obj;
		}
		
		public static function getRewardMessage(username:String,coins:int):Object {
			var obj:Object = {};
			obj.body = ResourceManager.getInstance().getString("message","every_reward_post_message",[username,coins]);
			obj.src = Config.getConfig("host") + "feed/feed_reward.png";
			return obj;
		}
		
		public static function getRequestGiftsMessage(username:String):Object {
			var obj:Object = {};
			obj.body = ResourceManager.getInstance().getString("message","request_gifts_message",[username]);
			obj.src = Config.getConfig("host") + "feed/request_gifts.png";
			return obj;
		}
		
		/**
		 * 要根据ID的名称给图片取名字
		 */ 
		public static function getSendGiftsToFriendMessage(username:String,friendName:String,gift_id:Number):Object {
			var obj:Object = {};
			obj.body = ResourceManager.getInstance().getString("message","send_gift_to_friend_message",[username,friendName]);
			obj.src = Config.getConfig("host") + "feed/send_gifts" + gift_id + ".png";
			return obj;
		}
	}
}