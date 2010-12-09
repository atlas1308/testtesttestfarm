package {
	import classes.ApplicationFacade;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Security;
	
	import mx.resources.ResourceManager;
	
	import tzh.core.Config;
	import tzh.core.Constant;
	import tzh.core.SoundManager;
	import tzh.core.VersionManager;
	
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
	 * 1.更新到好友家帮忙的功能
	 * 
	 * 
	 * 
	 * 1.动态的配置Skin的访问程序,和locale的配置形式是一样的,需要在配置swc的时候配置一下即可
	 * 
	 * 
	 * 
	 * 1.要更新用户删除地块时,好友帮助的时间应该也会被清除掉(但是这个逻辑不对了那就
	 * 2.卖出物品qty最小为0的验证
	 * 
	 * 3.新上的物品卖出的不多
	 * 
	 * 
	 * 
	 * 1.后台的数据ID里面有存在空格
	 * 
	 * 
	 * 1.ServerCallCommand没有用了
	 * 
	 * 
	 * 1.判断fence转向
	 * 
	 * 
	 * 
	 * 
	 * 1.更新了发送消息的功能
	 * 2.更新了买东西发送id=12的问题
	 * 3.增加了系统的延迟,大概是10秒左右
	 * 4.删除了一些没有用到的代码
	 * 
	 * 5.发送者的问题,显示的好像不正确
	 * 
	 * 
	 * 
	 * 
	 * 1.要优化RotateBtn这个东西在MapObject里的使用
	 * 
	 * 
	 * 
	 * 1.继续优化
	 * 2.branches里的嵌入的字体要修改
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
			
			//Config.setConfig("host","http://ec2-46-51-129-166.eu-west-1.compute.amazonaws.com/static/");//vz平台
			//Config.setConfig("transport","http://ec2-46-51-129-166.eu-west-1.compute.amazonaws.com/");
			Config.setConfig("host","http://localhost:80/static/");
			Config.setConfig("transport","http://localhost:80/");
			
			//Config.setConfig("transport","http://192.168.0.100/");
			/* Config.setConfig("transport","http://192.168.1.99:9903/");
			Config.setConfig("host","http://192.168.1.99:9903/static/"); */
			Config.setConfig("batch_delay",8000);
			Config.setConfig("loadSocialData","loadSocialData");
			Config.setConfig("version","2.0");// 这里
			Config.setConfig("release",new Date().toString());
			Config.setConfig("newsPopupTimes",1);
			Config.setConfig("timeDelay",10);
			var locale:String = ResourceManager.getInstance().locale;
			if(locale == "de"){
				locale = VersionManager.DE_VERSION;// 这里先做一个兼容
			}
			VersionManager.instance.version = locale;
			Config.setConfig("lang",locale);
			this.addEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
		}
		
		private function addToStageHandler(evt:Event = null):void {
			SoundManager.getInstance().addSound(Constant.BACKGROUND_KEY,Config.getConfig("host") + "sound/background.mp3");
			ApplicationFacade.getInstance(MAIN_STAGE).startup(this.stage);
		}
	}
}