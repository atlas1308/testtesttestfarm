package classes.view.components.popups
{
	import mx.resources.ResourceManager;
	

    public class ConfirmPopup extends DynamicPopup
    {
        public var obj:Object;

        public function ConfirmPopup(message:String, obj:Object)
        {
            this.obj = obj;
            super(400, 190, 300, 110, message);
        }

        override protected function init() : void
        {
            ok_label = ResourceManager.getInstance().getString("message","game_button_ok_message");
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
