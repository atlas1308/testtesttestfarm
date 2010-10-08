package classes.model
{
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.proxy.*;

    public class PopupProxy extends Proxy implements IProxy
    {
        private var queue:Array;
        public var can_show_popup:Boolean = true;
        public static const NAME:String = "PopupProxy";

        public function PopupProxy()
        {
            super(NAME);
            this.init();
        }

        private function init() : void
        {
            queue = new Array();
        }

        public function show_next_popup() : void
        {
            can_show_popup = true;
            if (queue.length == 0)
            {
                return;
            }
            var notification:INotification = queue.shift() as INotification;
            sendNotification(notification.getName(), notification.getBody());
        }

        public function add_popup(value:INotification) : void
        {
            trace("add popup", value.getName(), queue.length);
            queue.push(value);
        }

    }
}
