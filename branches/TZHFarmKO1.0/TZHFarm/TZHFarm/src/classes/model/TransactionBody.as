package classes.model
{
	/**
	 * 传递参数的购造类
	 */ 
    public class TransactionBody extends Object
    {
        private var _method:String;
        private var _channel:String;
        private var _data:Object;
        private var _required_params:Object;

        public function TransactionBody(_method:String, _channel:String, _data:Object = null, _required_params:Object = null)
        {
            this._method = _method;
            this._channel = _channel;
            this._data = _data;
            this._required_params = _required_params;
        }

        public function get method() : String
        {
            return _method;
        }

        public function get channel() : String
        {
            return _channel;
        }

        public function set_required_params(value:Object) : void
        {
            _required_params = value;
        }

        public function get parameters() : Object
        {
            var obj:Object = new Object();
            if (_data)// 特殊的传递的参数,比如初始化会传递一个fids
            {
                for (var dkey:String in _data)
                {
                    obj[dkey] = _data[dkey];
                }
            }
            if (_required_params)// 默认的传递的参数
            {
                for (var rkey:String in _required_params)
                {
                    obj[rkey] = _required_params[rkey];
                }
            }
            return obj;
        }

        public function add_parameter(key:String, value:Object) : void
        {
            if (!_data)
            {
                _data = new Object();
            }
            _data[key] = value;
        }

        public function toString() : String
        {
            var key:String = null;
            var result:String = "method: " + _method;
            result = result + (", channel: " + _channel);
            for (key in parameters)
            {
                result = result + (", " + key + ": " + parameters[key]);
            }
            return result;
        }

        public function get_batch_body() : Object
        {
            if (!_data)
            {
                return {};
            }
            return {method:_method, data:_data};
        }

    }
}
