package {
	import classes.ApplicationFacade;
	
	import com.adobe.serialization.json.JSON;
	
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
	 * 1.更新GreenHouse功能 已经修改OK,后台有些数据需要测试
	 * 2.更新部分代码,及语言 进行中
	 * 3.更新排序算法 进行中
	 * 4.更新礼物功能,以及页面上的功能 需要测试
	 * 5.功能代码 进行中
	 * 6.增加FG不够时跳转到充值页面
	 * 7.装饰可以不用弹出面板和种地一样,可以买一次就可以一直够买
	 * 8.更新了部分popup弹出的效果
	 * 
	 * 
	 * 
	 * 
	 * 
	 * 
	 * 功能更新
	 * 	a.更新遮挡物时显示出树,并且遮挡物的alpha
	 *  b.更新用心升级时,好友重新排序,要测试如果快速点击好友时的变化
	 *  c.更新了image里检测
	 *  d.更新GreenHouse功能,要测试删除GreenHouse,移动GreenHouse,移动地块,购买GreenHouse,购买原料
	 * 		等是否有问题
	 *  e.更新了部分代码优化
	 * 
	 * 
	 * 
	 * 1.要解决popup以及popup层级的问题
	 * 
	 * 
	 * 
	 * 
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
			//Config.setConfig("transport","http://devfarm.lf3g.com/");
			
			/* Config.setConfig("host","http://newfarm.lf3g.com/s tatic/");// 本机
			Config.setConfig("transport","http://newfarm.lf3g.com/");  */
			//Config.setConfig("host","http://ec2-46-51-129-166.eu-west-1.compute.amazonaws.com/static/");//vz平台
			//Config.setConfig("host","http://ec2-46-51-129-166.eu-west-1.compute.amazonaws.com/static/");//vz平台
			//Config.setConfig("transport","http://ec2-46-51-129-166.eu-west-1.compute.amazonaws.com/");
			//Config.setConfig("host","http://192.168.1.99:9901/static/");
			//Config.setConfig("transport","http://192.168.1.99:9901");
			//Config.setConfig("host","http://192.168.0.102/static/");
			//Config.setConfig("transport","http://192.168.0.102/");
			//Config.setConfig("host","http://192.168.0.102/static/");
			Config.setConfig("transport","http://192.168.0.102/");
			Config.setConfig("transport","http://192.168.1.105/");
			//Config.setConfig("transport","http://192.168.1.99:9901/");
			
			Config.setConfig("loadSocialData","loadSocialData");
			Config.setConfig("version","1.0");
			//Config.setConfig("lang","de-DE");
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