package classes.model
{
    import classes.*;
    import classes.utils.*;
    
    import flash.events.*;
    import flash.system.*;
    import flash.utils.clearTimeout;
    import flash.utils.setTimeout;
    
    import org.puremvc.as3.multicore.interfaces.IProxy;
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    
    import tzh.core.Config;

    public class TransactionProxy extends Proxy implements IProxy
    {
        private var serial_manager:TransactionManager;
        private var required_params:Object;
        private var batch_manager:TransactionManager;
        private var parameters:Object;
        private var error_dispatched:Boolean = false;
        public const SWF_VERSION:Number = 79;
        private static var gifts_popup_displayed:Boolean = false;
        private static var gifts_popup_interval:Number;
        public static const NAME:String = "TransactionProxy";

        public function TransactionProxy(value:Object)
        {
            super(NAME);
            parameters = value;
	        var url:String = Config.getConfig("transport") + "gateway.php";
            generate_required_params();
            batch_manager = new TransactionManager(url, true, required_params);
            serial_manager = new TransactionManager(url, false, required_params);
            batch_manager.addEventListener(batch_manager.ON_RESULT, on_result);
            batch_manager.addEventListener(batch_manager.ON_SAVE, on_save);
            batch_manager.addEventListener(batch_manager.ON_WAIT, on_wait);
            batch_manager.addEventListener(batch_manager.ON_IDLE, on_idle);
            batch_manager.addEventListener(batch_manager.ON_NETWORK_DELAY, onNetworkDelay);
            serial_manager.addEventListener(serial_manager.ON_RESULT, on_result);
        }

        private function onNetworkDelay(event:Event) : void
        {
            trace("onNetworkDelay");
            if (error_dispatched)
            {
                return;
            }
            error_dispatched = true;
            sendNotification(ApplicationFacade.SHOW_NETWORK_DELAY_POPUP);
        }

        private function on_idle(event:Event) : void
        {
            sendNotification(ApplicationFacade.DISABLE_SAVE_BUTTON);
        }

        private function generate_required_params() : void
        {
            required_params = new Object();
            for (var key:String in parameters)
            {
                /* if (key.indexOf("fb_sig") >= 0)// 这是里一个参数的过滤,只去验证fb_sig开头的数据,就是网页里加载的数据
                { */
                    required_params[key] = parameters[key];
               /*  } */
            }
            required_params.swf_version = SWF_VERSION;
        }

        public function set_data_hash(value:String):void
        {
            batch_manager.set_data_hash(value);
        }

        private function show_gifts_popup() : void
        {
            gifts_popup_displayed = true;
            if (app_data.can_show_gifts_page())
            {
                facade.sendNotification(ApplicationFacade.SHOW_SEND_GIFTS_POPUP);
            }
        }

        private function get app_data() : AppDataProxy
        {
            return facade.retrieveProxy(AppDataProxy.NAME) as AppDataProxy;
        }

        private function on_save(event:Event) : void
        {
            sendNotification(ApplicationFacade.ENABLE_SAVE_BUTTON, true);
        }

        public function add(value:TransactionBody, ON_IDLE:Boolean = false) : void
        {
            if (ON_IDLE)
            {
                batch_manager.add(value);
                clearTimeout(gifts_popup_interval);
                if (!gifts_popup_displayed)
                {
                    gifts_popup_interval = setTimeout(show_gifts_popup, 20000);
                }
            }
            else
            {
                if (value.channel == "retrieve")
                {
                    if (parameters.ranch_id)
                    {
                        value.add_parameter("ranch_id", parameters.ranch_id);
                    }
                }
                serial_manager.add(value);
            }
        }

        private function on_wait(event:Event) : void
        {
            sendNotification(ApplicationFacade.ENABLE_SAVE_BUTTON, false);
        }

        private function on_result(event:Event) : void
        {
            trace("error_dispatched", error_dispatched);
            if (error_dispatched)
            {
                sendNotification(ApplicationFacade.CLOSE_NETWORK_DELAY_POPUP);
            }
            error_dispatched = false;
            sendNotification(ApplicationFacade.HANDLE_TRANSACTION_RESULT, event.target.result);
        }

        public function save() : void
        {
            batch_manager.save();
        }
    }
}
