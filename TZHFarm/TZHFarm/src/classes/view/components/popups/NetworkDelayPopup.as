﻿package classes.view.components.popups
{
	import mx.resources.ResourceManager;
	

    public class NetworkDelayPopup extends DynamicPopup
    {

        public function NetworkDelayPopup(value:String)
        {
            super(380, 260, 300, 160, value);
        }

        override protected function init() : void
        {
            inner_cont_padd = 40;
            show_close_btn = false;
            ok_label = ResourceManager.getInstance().getString("message","game_button_refresh_message");
            super.init();
        }

    }
}
