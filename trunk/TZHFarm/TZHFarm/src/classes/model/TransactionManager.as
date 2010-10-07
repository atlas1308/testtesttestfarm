package classes.model
{
    import flash.events.*;
    import flash.utils.*;

    public class TransactionManager extends EventDispatcher
    {
        private var gateway_path:String;
        private var data_hash:String;
        private var timer:Timer;
        private var serial_queue:Array;
        private var batch_mode:Boolean;
        public const ON_NETWORK_DELAY:String = "onNetworkDelay";
        public const ON_WAIT:String = "onWait";
        private var batch_transaction:Transaction;
        private var batch_queue:Array;
        public var result:TransactionResult;
        private var required_params:Object;
        public const ON_SAVE:String = "onSave";
        public const ON_IDLE:String = "onIdle";
        public const ON_RESULT:String = "onResult";
        private var batch_delay:Number = 10000;

        public function TransactionManager(gateway_path:String, batch_mode:Boolean = false, required_params:Object = null)
        {
            this.gateway_path = gateway_path;
            this.batch_mode = batch_mode;
            this.required_params = required_params;
            this.init();
        }

        public function save() : void
        {
            if (batch_transaction.is_busy)
            {
                batch_transaction.retry_call();
            }
            else
            {
                timer.reset();
                timerComplete(null);
            }
        }

        protected function onTransactionResult(event:Event) : void
        {
            result = event.target.result as TransactionResult;
            dispatchEvent(new Event(ON_RESULT));
            Log.add("transaction manager result");
            if (batch_queue.length)
            {
                dispatchEvent(new Event(ON_WAIT));
                Log.add("wait");
            }
            else
            {
                Log.add("idle");
                dispatchEvent(new Event(ON_IDLE));
            }
            timer.reset();
            timer.start();
        }

        protected function init() : void
        {
            batch_queue = new Array();
            serial_queue = new Array();
            batch_transaction = new Transaction(gateway_path);
            timer = new Timer(batch_delay, 1);
            timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerComplete);
            batch_transaction.addEventListener(batch_transaction.ON_RESULT, onTransactionResult);
            batch_transaction.addEventListener(batch_transaction.ON_NETWORK_DELAY, onNetworkDelay);
        }

        protected function timerComplete(event:Event) : void
        {
            var transactionBody:TransactionBody = null;
            var obj:Object = null;
            timer.reset();
            var list:Array = new Array();
            var index:Number = 0;
            while (index < batch_queue.length)
            {
                transactionBody = TransactionBody(batch_queue[index]);
                list.push(transactionBody.get_batch_body());
                index++;
            }
            Log.add("queue length: " + list.length);
            if (list.length)
            {
                obj = new Object();
                obj.queue = list;
                if (data_hash)
                {
                    obj.data_hash = data_hash;
                }
                Log.add("batch call");
                trace("batch_transaction start", list.length);
                batch_transaction.start(new TransactionBody("execute_batch", "save_data", obj, required_params));
                dispatchEvent(new Event(ON_SAVE));
            }
            batch_queue = new Array();
        }

        public function add(value:TransactionBody) : void
        {
            var retrieveChannel:Boolean = false;
            var transaction:Transaction = null;
            if (batch_mode)
            {
                batch_queue.push(value);
                if (!batch_transaction.is_busy)
                {
                    dispatchEvent(new Event(ON_WAIT));
                    if (!timer.running)
                    {
                        timer.start();
                    }
                }
            }
            else
            {
                value.set_required_params(required_params);
                retrieveChannel = value.channel != "retrieve";
                transaction = new Transaction(gateway_path, value, retrieveChannel);
                serial_queue.push(transaction);
                transaction.addEventListener(transaction.ON_RESULT, onTransactionResult);
                transaction.start();
            }
        }

        public function set_data_hash(value:String) : void
        {
            this.data_hash = value;
        }

        protected function onNetworkDelay(event:Event) : void
        {
            dispatchEvent(new Event(ON_NETWORK_DELAY));
        }

    }
}
