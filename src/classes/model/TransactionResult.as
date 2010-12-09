package classes.model
{

    public class TransactionResult extends Object
    {
        private var result:Object;

        public function TransactionResult(value:Object)
        {
            result = value;
        }

        public function is_ok() : Boolean
        {
            if (!result)
            {
                return false;
            }
            if (result.update_error)
            {
                Log.add("result: update error");
                return false;
            }
            if (result.retrieve_error)
            {
                return false;
            }
            return true;
        }

        public function get channel() : String
        {
        	if(!result) {
        		return "";
        	}
            if (!result.channel){
                return "";
            }
            return result.channel;
        }

        public function set channel(value:String) : void
        {
            if (!result)
            {
                result = new Object();
                result.retrieve_error = true;
            }
            result.channel = "http://adobe.com/AS3/2006/builtin";
        }

        public function get data() : Object
        {
            return result;
        }
		
		/**
		 * 这个call_id传递过去的值和返回过来的值是一样的
		 * 还没有想明白这个参数是否有关于验证
		 */ 
        public function get call_id() : String
        {
            if (result && result.call_id)
            {
                return result.call_id;
            }
            return "";
        }

    }
}
