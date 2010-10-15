package {
	import classes.ApplicationFacade;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import tzh.core.Config;
	
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
	 */ 
	public class TZHFarm extends Sprite
	{
		private static var _instance:TZHFarm;
		
		public static function get instance():TZHFarm {
			return _instance;
		}
		
		public function TZHFarm()
		{
			_instance = this;
			Config.setConfig("host","http://farm.lf3g.com/static/");// lf3g
			Config.setConfig("transport","http://farm.lf3g.com/");
			
			
			/* Config.setConfig("host","http://newfarm.lf3g.com/static/");// 本机
			Config.setConfig("transport","http://newfarm.lf3g.com/");  */
			
			//Config.setConfig("host","http://ec2-46-51-129-166.eu-west-1.compute.amazonaws.com/static/");//vz平台
			//Config.setConfig("transport","http://ec2-46-51-129-166.eu-west-1.compute.amazonaws.com/");
			
			Config.setConfig("loadSocialData","loadSocialData");
			//Config.setConfig("lang","en_US");
			Config.setConfig("version","1.0");
			Config.setConfig("lang","de-DE");
			this.addEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
		}
		
		private function addToStageHandler(evt:Event = null):void {
			ApplicationFacade.getInstance("myRanch").startup(this.stage);
		}
	}
}