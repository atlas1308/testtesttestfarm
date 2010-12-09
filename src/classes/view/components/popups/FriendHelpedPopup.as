package classes.view.components.popups
{

    public class FriendHelpedPopup extends DynamicPopup
    {

        public function FriendHelpedPopup(value:String)
        {
            super(380, 210, 300, 110, value);
        }

        override protected function init() : void
        {
            inner_cont_padd = 40;
            show_close_btn = false;
            super.init();
        }

    }
}
