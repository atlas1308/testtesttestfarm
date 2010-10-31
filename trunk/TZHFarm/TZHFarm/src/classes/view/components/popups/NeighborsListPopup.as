package classes.view.components.popups
{
    import classes.view.components.buttons.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.utils.Dictionary;
    
    import mx.resources.ResourceManager;

    public class NeighborsListPopup extends ComplexPopup
    {
        private var last_selected:NeighborsListPopupItem;
        private var caption:Sprite;
        private var next_btn:GameButton;
        private var popup:DynamicPopup;
        private var caption_txt:TextField;
        public static const NEXT_CLICKED:String = "nextClicked";
		
		private var neighborsMap:Dictionary = new Dictionary(true);
		
        public function NeighborsListPopup(value:Object)
        {
            super(ResourceManager.getInstance().getString("message","neighbors_list_message"), value.list, 680, 470, 515, 300);
        }

        private function onSelect(event:Event) : void
        {
            if (last_selected)
            {
                last_selected.unselect();
            }
            last_selected = event.target as NeighborsListPopupItem;
        }

        private function nextClicked(event:MouseEvent) : void
        {
            if (!last_selected)
            {
                popup = new DynamicPopup(380, 260, 300, 160, ResourceManager.getInstance().getString("message","neighbors_list_popup_message"),false);
                popup.addEventListener(DynamicPopup.ON_ACCEPT, onClosePopup);
                popup.hide_close_btn();
                popup.set_ok_label(ResourceManager.getInstance().getString("message","game_button_ok_message"));
                popup.set_ok_fixed_width(100);
                content.addChild(popup);
            }
            else
            {
                dispatchEvent(new Event(NEXT_CLICKED));
            }
        }

        override protected function init() : void
        {
            items_x = 3;
            items_y = 4;
            next_btn = new GameButton(ResourceManager.getInstance().getString("message","game_button_next_message"), 22);
            caption = new Sprite();
            var textFormat:TextFormat = get_text_format();
            textFormat.size = 15;
            textFormat.color = 10049312;
            textFormat.align = TextFieldAutoSize.LEFT;
            caption_txt = create_tf(450, 40, textFormat);
            caption.addChild(caption_txt);
            caption_txt.text = ResourceManager.getInstance().getString("message","send_present_message");
            super.init();
            inner_cont_padd = 55;
            content.addChild(next_btn);
            content.addChild(caption);
            draw_inner_cont(caption, 450, 40);
            caption_txt.y = (40 - caption_txt.textHeight) / 2;
            caption_txt.x = (450 - caption_txt.textWidth) / 2;
            next_btn.addEventListener(MouseEvent.CLICK, nextClicked);
        }

        private function onUnselect(event:Event) : void
        {
            if (last_selected)
            {
                last_selected = null;
            }
        }

        override protected function create_item(value:Object) : PopupItem
        {
            var neighborsListPopupItem:NeighborsListPopupItem = new NeighborsListPopupItem(value);
            neighborsListPopupItem.addEventListener(NeighborsListPopupItem.ON_SELECT, onSelect);
            neighborsListPopupItem.addEventListener(NeighborsListPopupItem.ON_UNSELECT, onUnselect);
            return neighborsListPopupItem;
        }

        private function onClosePopup(event:Event) : void
        {
            popup.remove();
        }

        override protected function alignButtons() : void
        {
            super.alignButtons();
            next_btn.x = inner_cont.x + msg_w - next_btn.width;
            next_btn.y = inner_cont.y + msg_h + (_h - inner_cont.y - msg_h - next_btn.height) / 2;
            caption.x = (_w - 450) / 2;
            caption.y = tf.y + tf.height + 5;
        }

        public function get selected_neighbor():String
        {
            return last_selected.id;
        }

    }
}
