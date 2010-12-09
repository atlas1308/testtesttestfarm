package tzh.core
{
	public class VersionManager
	{
		public static const PL_VERSION:String = "pl";
		
		public static const DE_VERSION:String = "de-DE";
		
		private static var _instance:VersionManager;
		
		public static function get instance():VersionManager {
			if(_instance == null){
				_instance = new VersionManager();
			}
			return _instance;
		}
		
		private var _version:String;// 版本
		
		public function set version(value:String):void {
			this._version = value;
		}
		
		public function get version():String {
			return this._version;
		}
		
		public function get pl():Boolean {
			return version == PL_VERSION;
		}
		
		
		public function VersionManager()
		{
		}
		
		

	}
}