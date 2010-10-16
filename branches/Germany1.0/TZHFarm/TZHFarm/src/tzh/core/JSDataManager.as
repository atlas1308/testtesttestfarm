package tzh.core
{
	import flash.external.ExternalInterface;
	import flash.net.URLLoaderDataFormat;
	
	/**
	 * 鱼的代码里应该也要提供类似于这样子的一个管理器
	 * 农场现在需要的几个属性
	 * name 
	 * pic 
	 * uid
	 * 和鱼的属性上有一些差别,所以JS得需要修改一下
	 * 
	 * 这个应该在下一个或几个版本或者新游戏时,应该把这些统一了,这样就方便多了
	 */ 
	public class JSDataManager
	{
		public function JSDataManager()
		{
		}
		
		public function loadSocailData():void {
			var result:Object = null;
			var functionName:String = Config.getConfig("loadSocialData").toString();// 获取用户的信息
			try {
				result = ExternalInterface.call(functionName) as Object;
			}catch(error:Error){
				trace("load js error" + error.message);
			}
			if(result){
				_userInfo = result.user;
				for(var key:String in _userInfo){
					trace("vae " + _userInfo[key]);
				}
				_friends = result.friends;
				_fids = result.friendIds;
				trace("_fids " + _fids);
			}
		}
		
		private var _userInfo:Object = new Object();
		
		public function get userInfo():Object {
			return this._userInfo;
		}
		
		private var _friends:Object = new Object();
		
		public function get friends():Object {
			return this._friends;
		}
		
		private var _fids:String;
		
		public function get fids():String {
			return this._fids;
		}
		
		private static var model:JSDataManager;
		
		public static function getInstance():JSDataManager {
			if(model == null){
				model = new JSDataManager();
			}
			return model;
		}
		
		private static function toString(value:Object):void {
			var result:String;
			for(var key:String in value){
				result += " key :" + key + " value :" + value[key] + " ";
			}
			trace("result" + result);
		}
		
		/**
		 * 弹出邀请好友链接
		 */ 
		public static function showInviteFriendPage():void {
			var functionName:String = "showFriends";
			trace("ExternalInterface.call showFriends");
			try{
				ExternalInterface.call(functionName);
			}catch(error:Error){
				trace(functionName + " error");
			}
		}
		
		public static function reload():void {
			var functionName:String = "HV.reload";
			trace("ExternalInterface.call " + functionName);
			try{
				ExternalInterface.call(functionName);
			}catch(error:Error){
				trace(functionName + " error");
			}
		}
		
		/**
		 * 弹出JS的支付面板
		 */ 
		public static function showPayPage():void {
			var functionName:String = "showPayPage";
			trace("ExternalInterface.call showPayPage");
			try{
				ExternalInterface.call(functionName);
			}catch(error:Error){
				trace(functionName + " error");
			}
		}
		
		public function getUserInfoById(value:Object):Object {
			var uid:String = value.uid;
			var friend:Object = null;
			for each(var obj:Object in friends){
				if(uid == obj.uid){
					friend = obj;
					break;
				}
			}
			return friend;
		}
		
		public function merge(value:Object):Object {
			var friend:Object = getUserInfoById(value);
			if(friend){// 如果有值则合并
				for(var key:String in friend){
					value[key] = friend[key];
				}
			}
			return value;
		}
		
		/**
		 * title
		 * action_text
		 * src
		 * target_id 是当前的用户的ID
		 */ 
		public function postFeed(args:Object = null,callback:Function = null):void {
			var functionName:String = "postActivity";
			if(!args){
				args = {};
			}
			try {
				trace("run action " + functionName);
				ExternalInterface.call(functionName,args);
			}catch(error:Error){
				trace(functionName + " error " + error.message);
			}
		}
		
		/**
		 * 发送notice
		 * 这个JS方法有一些问题,应该也是传递一个Object,尽量不要分开
		 * JS里的这个方法要修改
		 */ 
		public function sendNotice(args:Object = null,callback:Function = null):void {
			var functionName:String = "sendNotice";
			if(!args){
				args = {};
			}
			try {
				ExternalInterface.call(functionName,args);
			}catch(error:Error){
				trace(functionName + " error " + error.message);
			}
		}
		
		
		public function uploadPhoto(path:String,caption:String):void {
			var functionName:String = "HV.camera";
			try {
				ExternalInterface.call(functionName,path,caption);
			}catch(error:Error){
				trace(functionName + " error " + error.message);
			}
		}
	}
}