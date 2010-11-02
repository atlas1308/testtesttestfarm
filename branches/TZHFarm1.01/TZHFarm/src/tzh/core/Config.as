package tzh.core
{
	import flash.utils.Dictionary;
	
	public class Config
	{
		private static var dictionary:Dictionary = new Dictionary(true);
		
		public static function setConfig(name:String,value:Object):void {
			dictionary[name] = value; 
		}
		
		/**
		 * @name:String 具体的key值
		 * 具体的外部传入的params我们也是同样能获取的
		 */ 
		public static function getConfig(name:String):Object {
			var v:String = "";
			var system:TZHFarm = TZHFarm.instance;
			if(system){
				if(system.stage){
					v = system.stage.loaderInfo.parameters[name];
				}else if(system.parent){
					v = system.parent.loaderInfo.parameters[name];
				}else {
					v = system.loaderInfo.parameters[name];
				}
			}
			if(v != null && v != ""){
				return v;
			}else {
				v = dictionary[name];
			}
			if(v != null && v != ""){
				return v;
			}else {
				return "";
			}
		}
	}
}