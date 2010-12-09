package tzh.core
{
	public class DateUtil
	{
		public function DateUtil()
		{
		}

		
		/**
		 * 是否已经超过一定的时间的期限
		 * @param systemTime:Number 当前的系统时间
		 * @param time:Number 固定的一个时间
		 * @param day:int 几天,目前只支持天数,暂时不支持小时
		 */ 
		public static function expired(systemTime:Number,time:Number,day:Number = 1):Boolean {
			var diff:Number = systemTime - time;
			if(diff <= 0){
				return false;
			}
			var temp:int = Math.floor(diff / 86400);
			if(temp > day){
				return true;
			}
			return false;
		}
		
		/**
		 * 转化成时间字符串,这里只做了一个处理
		 * YYYY-MM-DD HH:MM:SS
		 */ 
		public static function getFormatterDate(value:Number):String {
			var result:String;
			var date:Date = new Date(value * 1000);
			var ymd:Array = [];
			ymd.push(date.getFullYear());
			ymd.push(addZero(date.getMonth() + 1));
			ymd.push(addZero(date.getDate()));
			var hms:Array = [];
			hms.push(addZero(date.getHours()));
			hms.push(addZero(date.getMinutes()));
			hms.push(addZero(date.getSeconds()));
			result = ymd.join("-") + " " + hms.join(":");
			return result;
		}
		
		public static function addZero(value:Number):String {
			var result:String = value.toString();
			if(!isNaN(value) && value < 10){
				result = "0" + value;
			}
			return result;
		}
	}
}