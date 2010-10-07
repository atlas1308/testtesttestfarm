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
		
	}
}