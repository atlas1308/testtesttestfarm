package classes.view.components.popups
{
    import classes.view.components.buttons.*;
    
    import flash.events.*;
    import flash.text.*;
    
    import mx.resources.ResourceManager;

    public class LevelUpPopup extends BasicPopup
    {
        private var share_btn:GameButton;
        private var _close_btn:GameButton;
        private var data:Object;

        public function LevelUpPopup(value:Object)
        {
            this.data = value;
            super(new LevelUpPopupContainer());
        }

        override protected function init() : void
        {
            var label:String = null;
            super.init();
            content.cont.received.text = data.received;
            content.cont.level.text = data.level;
            content.content_placeholder.visible = false;
            if (data.can_buy)
            {
                content.cont.can_buy.text = data.can_buy;
                content.cont.can_buy.autoSize = TextFieldAutoSize.LEFT;
            }
            else
            {
                content.cont.removeChild(content.cont.can_buy);
                content.cont.removeChild(content.cont.can_buy_txt);
            }
            if (data.can_gift)
            {
                content.cont.can_gift.text = data.can_gift;
                content.cont.can_gift.autoSize = TextFieldAutoSize.LEFT;
            }
            else
            {
                content.cont.removeChild(content.cont.can_gift);
                content.cont.removeChild(content.cont.can_gift_txt);
            }
            content.cont.y = content.content_placeholder.y + (content.content_placeholder.height - content.cont.height) / 2;
            /* if (is_valid())
            { */
                label = ResourceManager.getInstance().getString("message","game_button_share_friends_message");
            /* }
            else
            {
                label = ResourceManager.getInstance().getString("message","game_button_ok_message");
            } */
            share_btn = new GameButton(label, 21, 23 / 21);
            _close_btn = new GameButton(ResourceManager.getInstance().getString("message","game_button_close_message"), 21, 23 / 21);
            _close_btn.set_colors(11534336, 13959168, 7405568);
            content.addChild(share_btn);
            content.addChild(_close_btn);
            var ww:Number = share_btn.width + 20 + _close_btn.width;
            share_btn.y = content.content_placeholder.y + content.content_placeholder.height + 15;
            _close_btn.y = share_btn.y;
            share_btn.x = content.content_placeholder.x + (content.content_placeholder.width - ww) / 2;
            _close_btn.x = share_btn.x + share_btn.width + 20;
            share_btn.addEventListener(MouseEvent.CLICK, acceptClicked);
            _close_btn.addEventListener(MouseEvent.CLICK, closeClicked);
        }

        public function is_valid() : Boolean
        {
            if (!data.user_has_name)
            {
                return false;
            }
            return true;
        }

    }
}
