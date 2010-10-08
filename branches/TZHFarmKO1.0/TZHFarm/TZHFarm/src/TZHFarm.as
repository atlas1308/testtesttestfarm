package {
	import classes.ApplicationFacade;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import tzh.core.Config;
	
	[SWF(width=760,height=600,backgroundColor=0xFFFFFF,frameRate=20)]
	[Frame(factoryClass="classes.view.Preloader")] 
	[ResourceBundle("message")]  
	public class TZHFarm extends Sprite
	{
		private static var _instance:TZHFarm;
		
		public static function get instance():TZHFarm {
			return _instance;
		}
		
		public function TZHFarm()
		{
			_instance = this;
			Config.setConfig("host","http://farm.lf3g.com/static/");
			Config.setConfig("version","1.0");
			Config.setConfig("transport","http://farm.lf3g.com/");
			Config.setConfig("loadSocialData","loadSocialData");
			this.addEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
		}
		
		private function addToStageHandler(evt:Event = null):void {
			ApplicationFacade.getInstance("myRanch").startup(this.stage);
		}
	}
}