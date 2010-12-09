package classes.view.components.popups
{
    import classes.view.components.*;
    import flash.events.*;

    public class SendGiftsPopup extends DynamicPopup
    {
        private var gift_box:GiftBox;

        public function SendGiftsPopup(value:String)
        {
            super(380, 210, 300, 110, value);
        }

        private function enterFrame(event:Event) : void
        {
            gift_box.disable_button();
            gift_box.removeEventListener(Event.ENTER_FRAME, enterFrame);
        }

        override protected function init() : void
        {
            inner_cont_padd = 40;
            super.init();
            gift_box = new GiftBox();
            content.addChild(gift_box);
            gift_box.x = 13;
            gift_box.y = 13;
            gift_box.addEventListener(Event.ENTER_FRAME, enterFrame);
        }

    }
}
