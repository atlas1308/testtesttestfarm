package {
	import classes.ApplicationFacade;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Security;
	
	import mx.resources.ResourceManager;
	
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
	 * 后台对于加工厂的处理还是有错误
	 * 	暂时还没有对selected_raw_material的处理,
	 *  应该尽快对这条数据处理,表示选择原料的索引
	 *  从raw_material[0] 里去寻找就可以找到了
	 *  比如refill时会传递一个raw_material,比如这个raw_material=42
	 *  那么selected_raw_material=0,
	 *  如果raw_material=58
	 *  那么selected_raw_material=2,
	 *  ),
	    61 => (Object) array(
	        'raw_material' => array (
	            0 => array (
	                0 => 42,
	                1 => 49,
	                2 => 58,
	                3 => 60,
	                4 => 84,
	                5 => 86,
	                6 => 88,
	                7 => 133,
	            ),
	            1 => 46,
	        ),
	        'product' => array (
	            0 => 62,
	            1 => 63,
	            2 => 64,
	            3 => 65,
	            4 => 89,
	            5 => 90,
	            6 => 91,
	            7 => 134,
	        )
	    ),
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
			Security.allowDomain("*");
			//Config.setConfig("host","http://farm.lf3g.com/static/");// lf3g
			//Config.setConfig("transport","http://farm.lf3g.com/");
			
			/* Config.setConfig("host","http://newfarm.lf3g.com/static/");// 本机
			Config.setConfig("transport","http://newfarm.lf3g.com/");  */
			//Config.setConfig("host","http://ec2-46-51-129-166.eu-west-1.compute.amazonaws.com/static/");//vz平台
			//Config.setConfig("host","http://ec2-46-51-129-166.eu-west-1.compute.amazonaws.com/static/");//vz平台
			Config.setConfig("transport","http://ec2-46-51-129-166.eu-west-1.compute.amazonaws.com/");
			
			Config.setConfig("loadSocialData","loadSocialData");
			//Config.setConfig("lang","en_US");
			Config.setConfig("version","1.0");
			Config.setConfig("lang",ResourceManager.getInstance().locale);
			//Config.setConfig("lang","pt");
			this.addEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
		}
		
		private function addToStageHandler(evt:Event = null):void {
			SoundManager.getInstance().addSound(Constant.BACKGROUND_KEY,Config.getConfig("host") + "sound/background.mp3");
			ApplicationFacade.getInstance("myRanch").startup(this.stage);
		}
	}
}