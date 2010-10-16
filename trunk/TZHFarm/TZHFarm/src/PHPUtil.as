package
{
	public class PHPUtil
	{
		public function PHPUtil()
		{
		}
		
		/**
		 * 解析生成类似于PHP的脚本
		 * @param value:Object 
		 * @param removeabled:Boolean true 删除0 "" 等false
		 */ 
		private static function deepString(value:Object,removeabled:Boolean = true):String
        {
            var str:String = "";
            if (value == null)
            {
                str = "NULL";
            }
            else if (typeof(value) == "object")
            {
                str = str + "(\n";
                for (var key:* in value)
                {
                	var result:* = value[key];
                	if(!isNaN(key)){// 这是索引号
                		str = str + (key + " => array " + deepString(result) + ",\n");
                	}else {
                		if(removeabled){
	                		if(toBoolean(result)){
	                    		str = str + ("      "+ "'" + key + "'" + " => " + deepString(result) + ",\n");
	                    	}
                    	}else {
                    		str = str + ("      "+ "'" + key + "'" + " => " + deepString(result) + ",\n");
                    	}
                    }
                }
                str = str + ")";
            }
            else
            {
                str = String(value);
            }
            return str;
        }
        
        public static function getPHPCode(value:Object):String {
        	var temp:String = deepString(value);
        	var lastDotIndex:int = temp.lastIndexOf(",");
        	var now:String = temp.substr(0,lastDotIndex);// 最后一行,可能多一个,,就用最笨的办法,先把那断截取出来,然后再加上个新的
        	var result:String = now.concat("\n)");
        	return result;
        }
        
        public static function toBoolean(value:Object):Boolean {
        	var result:Boolean;
        	if(value != null && value != "" && value != "0" && value != "undefined"){
        		result = true;
        	}
        	return result;
        }
	}
}