package classes.view.components.popups
{

    public class SendGiftsPopupItem extends PopupItem
    {

        public function SendGiftsPopupItem(param1:Object)
        {
            param1.button_label = "Send Gifts";
            param1.width = 125;
            param1.height = 160;
            param1.title_txt = "Send materials to friends!";
            super(param1);
            return;
        }

        override protected function init() : void
        {
            title_color = 3968452;
            title_size = 20;
            title_width = 125;
            image_w = 0;
            image_h = 0;
            super.init();
            button.set_style("blue");
            return;
        }

        override protected function align() : void
        {
            title.x = (data.width - title.width) / 2;
            button.x = (data.width - button.width) / 2;
            title.y = (data.height - button.height / 2 - title.height) / 2;
            button.y = data.height - button.height / 2;
            return;
        }

    }
}
