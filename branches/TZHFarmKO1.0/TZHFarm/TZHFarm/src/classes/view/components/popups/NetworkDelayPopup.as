package classes.view.components.popups
{

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
            ok_label = "REFRESH";
            super.init();
        }

    }
}
