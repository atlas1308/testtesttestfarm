package classes.model
{
    import classes.utils.*;
    
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class Transaction extends EventDispatcher
    {
        protected var gateway_path:String;
        protected var responder:Responder;
        protected var timer:Timer;
        protected var gateway:NetConnection;
        public const ON_NETWORK_DELAY:String = "onNetworkDelay";
        protected var retry:Boolean;
        protected var call_id:Number;
        public var result:TransactionResult;
        protected var body:TransactionBody;
        protected var max_delay:Number = 30000;
        protected var retry_delay:Number = 50000;
        protected var retry_times:int = 1;// 重发几次
        protected var _is_busy:Boolean = false;
        protected var network_delay:Number = 120000;
        protected var max_delay_timer:Timer;
        protected var received_calls:Array;
        public const ON_RESULT:String = "onResult";
        protected var network_delay_timer:Timer;

        public function Transaction(gateway_path:String, body:TransactionBody = null, retry:Boolean = true) : void
        {
            this.body = body;
            this.gateway_path = gateway_path;
            this.retry = retry; 
            this.init();
        }

        protected function onFault(body:Object) : void
        {
            Log.add("fault");
            retry_call(true);
        }

        public function get is_busy() : Boolean
        {
            return _is_busy;
        }

        protected function onNetStatus(event:NetStatusEvent) : void
        {
            retry_call(true);
        }

        protected function timerHandler(event:TimerEvent) : void
        {
            retry_call();
        }

        protected function onAsyncError(event:AsyncErrorEvent) : void
        {
            Log.add("async error");
            retry_call(true);
        }

        protected function maxDelayReached(event:TimerEvent) : void
        {
            var result:TransactionResult = new TransactionResult(null);
            result.channel = body.channel;
            dispatchEvent(new Event(ON_RESULT));
        }

        protected function onIOError(event:IOErrorEvent) : void
        {
            Log.add("io error");
            retry_call(true);
        }

        protected function init() : void
        {
            timer = new Timer(retry_delay,retry_times);
            max_delay_timer = new Timer(max_delay, 1);
            network_delay_timer = new Timer(network_delay, 1);
            gateway = new NetConnection();
            gateway.objectEncoding = ObjectEncoding.AMF3;
            NetConnection.defaultObjectEncoding = ObjectEncoding.AMF3;
            responder = new Responder(onResult, onFault);
            received_calls = new Array();
            gateway.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
            gateway.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            gateway.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
            timer.addEventListener(TimerEvent.TIMER, timerHandler);
            max_delay_timer.addEventListener(TimerEvent.TIMER_COMPLETE, maxDelayReached);
            network_delay_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onNetworkDelay);
            try
            {
                gateway.connect(gateway_path);
            }
            catch (e:Error)
            {
                Log.add("gateway could not connect");
                result = new TransactionResult(null);
                dispatchEvent(new Event(ON_RESULT));
            }
        }
	
        protected function call_server(flag:Boolean = true) : void
        {
            var params:Object = body.parameters;
            if (flag)
            {
                call_id = Algo.milliseconds();
                network_delay_timer.start();
            }
            params.call_id = "call" + call_id;
            Log.add("swf version: " + params.swf_version);
            Log.add("data hash: " + params.data_hash);
            Log.add("call id: " + call_id);
            gateway.call("DataHandler.handle", responder, body.method, params, body.channel);
            _is_busy = true;
            if (retry)
            {
                timer.reset();
                timer.start();
            }
            else
            {
                max_delay_timer.start();
            }
        }

        public function start(value:TransactionBody = null) : void
        {
            Log.add("transaction start");
            if (value){
                this.body = value;
            }
            call_server();
        }

        public function retry_call(body:Boolean = false) : void
        {
            if (!retry)
            {
                return;
            }
            if (received_calls[call_id])
            {
                Log.add("retry stopped - call received");
                return;
            }
            if (body)
            {
                if (timer.running)
                {
                    return;
                }
                timer.reset();
                timer.start();
            }
            Log.add("retry");
            call_server(false);
        }

        protected function onResult(body:Object) : void
        {
            timer.reset();
            max_delay_timer.reset();
            result = new TransactionResult(body);
            if (!received_calls[result.call_id])
            {
                network_delay_timer.reset();
                if (result.is_ok())
                {
                    received_calls[result.call_id] = true;
                    Log.add("result dispatched");
                    dispatchEvent(new Event(ON_RESULT));
                    _is_busy = false;
                }
                else if (retry)
                {
                    Log.add("result retry");
                    timer.start();
                }
                else
                {
                    dispatchEvent(new Event(ON_RESULT));
                }
            }
        }

        protected function onNetworkDelay(event:TimerEvent) : void
        {
            dispatchEvent(new Event(ON_NETWORK_DELAY));
        }

    }
}
