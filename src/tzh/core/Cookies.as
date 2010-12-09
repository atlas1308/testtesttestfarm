package tzh.core
{
	import flash.net.SharedObject;
	
	public class Cookies
	{
		public static const LOCAL_PATH:String = "/";
		public function Cookies()
		{
		}
		
		public static function addCookies(name:String,value:*):void {
			try {
				var so:SharedObject = SharedObject.getLocal(name,LOCAL_PATH);
				so.data[name] = value;
				so.flush();
			}catch(error:Error){
				trace("flush ShareObject error" + error.message);
			}
		}
		
		public static function removeCookies(name:String):void {
			try {
				var so:SharedObject = SharedObject.getLocal(name,LOCAL_PATH);
				so.clear();
			}catch(error:Error){
				trace("getCookies" + error.message);
			}
		}
		
		public static function getCookies(name:String):Object {
			try {
				var so:SharedObject = SharedObject.getLocal(name,LOCAL_PATH);
				var result:Object = so.data[name];
				return result;
			}catch(error:Error){
				trace("getCookies error" + error.message);
			}
			return {};
		}
		
		public static function hasCookies(name:String):Boolean {
			var result:Boolean;
			try {
				var so:SharedObject = SharedObject.getLocal(name,LOCAL_PATH);
				if(so.data.hasOwnProperty(name)){
					result = true;
				}
			}catch(error:Error){
				trace("getCookies" + error.message);
			}
			return result;
		}
	}
}