package {
	import classes.ApplicationFacade;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Security;
	
	import tzh.core.Config;
	import tzh.core.Constant;
	import tzh.core.SoundManager;
	
	[SWF(width=760,height=600,backgroundColor=0xFFFFFF,frameRate=20)]
	[Frame(factoryClass="classes.view.Preloader")] 
	[ResourceBundle("message")]  
	
	/**
	 * 编译参数CONFIG::release的使用
	 * 注意配置一些这种参数,能尽量的修改少一些代码
	 * 
	 * 如果是发布时请记得把
	 * Action Complier里的参数CONFIG::debug,false CONFIG::debug,true
	 * 
	 * 修改问题
	 * 
	 * 初始化用户购买化肥时,会出现升级的bug
	 * 
	 * 蜜蜂采蜜有Bug
	 * 
	 * 购买Jam有bug,不能同时操作
	 * 
	 * 
	 * 修改JS里devel_replace 这个去掉,不分隔
	 * 
	 * 1.更新GreenHouse功能
	 * 2.更新部分代码,及语言
	 * 3.更新排序算法
	 * 4.更新礼物功能,以及页面上的功能
	 * 5.功能代码
	 * 
	 * 
	 * 
	 * 
	 * 
	 * 
	 * 功能更新
	 * 	a.更新遮挡物时显示出树,并且遮挡物的alpha
	 *  b.更新用心升级时,好友重新排序,要测试如果快速点击好友时的变化
	 *  c.更新image,不加随机参数,好友列表在IE下显示不出来头像的问题,还应该仔细查一查.
	 *  d.更新GreenHouse功能,要测试删除GreenHouse,移动GreenHouse,移动地块,购买GreenHouse,购买原料
	 * 		等是否有问题
	 *  e.更新了部分代码优化
	 */ 
	 
	public class TZHFarm extends Sprite
	{
		private static var _instance:TZHFarm;
		
		public static const MAIN_STAGE:String = "myRanch";
		public static function get instance():TZHFarm {
			return _instance;
		}
		
		public function TZHFarm()
		{
			_instance = this;
			Security.allowDomain("*");
			//Config.setConfig("host","http://farm.lf3g.com/static/");// lf3g
			//Config.setConfig("transport","http://farm.lf3g.com/");
			//Config.setConfig("transport","http://newfarm.lf3g.com/");
			
			/* Config.setConfig("host","http://newfarm.lf3g.com/static/");// 本机
			Config.setConfig("transport","http://newfarm.lf3g.com/");  */
			//Config.setConfig("host","http://ec2-46-51-129-166.eu-west-1.compute.amazonaws.com/static/");//vz平台
			//Config.setConfig("host","http://ec2-46-51-129-166.eu-west-1.compute.amazonaws.com/static/");//vz平台
			//Config.setConfig("transport","http://ec2-46-51-129-166.eu-west-1.compute.amazonaws.com/");
			Config.setConfig("transport","http://192.168.1.99:9901");
			
			Config.setConfig("loadSocialData","loadSocialData");
			Config.setConfig("version","1.0");
			Config.setConfig("lang","en-US");
			//Config.setConfig("lang","pt");
			this.addEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
		}
		
		private function addToStageHandler(evt:Event = null):void {
			SoundManager.getInstance().addSound(Constant.BACKGROUND_KEY,Config.getConfig("host") + "sound/background.mp3");
			//SoundManager.getInstance().addSound(Constant.BACKGROUND_KEY,"music3.mp3");
			ApplicationFacade.getInstance(MAIN_STAGE).startup(this.stage);
		}
	}
}