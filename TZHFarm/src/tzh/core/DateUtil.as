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
		public static function expired(systemTime:Number,time:Number,day:int = 1):Boolean {
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
	}
}