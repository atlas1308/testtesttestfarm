package classes.view.components.popups
{
	import mx.resources.ResourceManager;
	

    public class SendGiftsPopupItem extends PopupItem
    {

        public function SendGiftsPopupItem(value:Object)
        {
            value.button_label = ResourceManager.getInstance().getString("message","send_gifts_popup_items_title_message");
            value.width = 125;
            value.height = 160;
            value.title_txt = ResourceManager.getInstance().getString("message","send_gifts_popup_items_materials_message");
            super(value);
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
        }

        override protected function align() : void
        {
            title.x = (data.width - title.width) / 2;
            button.x = (data.width - button.width) / 2;
            title.y = (data.height - button.height / 2 - title.height) / 2;
            button.y = data.height - button.height / 2;
        }

    }
}
