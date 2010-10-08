package classes.view.components.popups
{

    public class ConfirmPopup extends DynamicPopup
    {
        public var obj:Object;

        public function ConfirmPopup(param1:String, param2:Object)
        {
            this.obj = param2;
            super(400, 190, 300, 110, param1);
        }

        override protected function init() : void
        {
            ok_label = "OK";
            super.init();
        }

        public function get notif_body() : Object
        {
            return obj.data;
        }

        public function get notif_name() : String
        {
            return obj.notif;
        }

    }
}
