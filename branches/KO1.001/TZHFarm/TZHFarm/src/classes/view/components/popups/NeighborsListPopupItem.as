package classes.view.components.popups
{
    import classes.utils.*;
    
    import flash.display.*;
    import flash.events.*;
    
    import mx.resources.ResourceManager;

    public class NeighborsListPopupItem extends PopupItem
    {
        private var checkbox:Checkbox;
        private var padd:Number = 5;
        public static const ON_SELECT:String = "onSelect";
        public static const ON_UNSELECT:String = "onUnselect";

        public function NeighborsListPopupItem(value:Object)
        {
            value.width = 160;
            value.height = 65;
            value.button_label = ResourceManager.getInstance().getString("message","game_button_ok_message");
            super(value);
        }

        override protected function align() : void
        {
            var _loc_1:* = (data.height - image_h) / 2;
            image_cont.y = (data.height - image_h) / 2;
            title.y = _loc_1;
            image_cont.x = padd;
            title.x = image_cont.x + image_w + padd;
            checkbox.y = data.height - 22;
            checkbox.x = data.width - padd - checkbox.width;
            return;
        }

        private function onMouseOut(event:MouseEvent) : void
        {
            refresh_bg();
        }

        private function onMouseClick(event:MouseEvent) : void
        {
            checkbox.checkmark.visible = !checkbox.checkmark.visible;
            refresh_bg();
            if (checkbox.checkmark.visible)
            {
                dispatchEvent(new Event(ON_SELECT));
            }
            else
            {
                onMouseOver(null);
                dispatchEvent(new Event(ON_UNSELECT));
            }
            return;
        }

        private function refresh_bg() : void
        {
            if (checkbox.checkmark.visible)
            {
                draw(16307865, 16639677);
                draw_checkbox(15911812);
            }
            else
            {
                draw();
                draw_checkbox();
            }
        }

        override protected function create_objects() : void
        {
            image_w = 50;
            image_h = 50;
            container = new Sprite();
            image_cont = new Sprite();
            checkbox = new Checkbox();
            container.addChild(image_cont);
            addChild(container);
            container.addChild(checkbox);
            container.mouseChildren = false;
            draw_checkbox();
            checkbox.checkmark.visible = false;
            cache = new Cache();
            cache.addEventListener(Cache.LOAD_COMPLETE, onImageLoadComplete);
            if (data.image)
            {
                cache.load(data.image);
            }
            title = create_tf(title_size, title_color, title_width, "", "left");
            title.width = data.width - image_w - 3 * padd - checkbox.width;
            container.addChild(title);
            if (data.title_txt)
            {
                title.text = data.title_txt;
            }
            addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            addEventListener(MouseEvent.CLICK, onMouseClick);
        }

        public function unselect() : void
        {
            checkbox.checkmark.visible = false;
            refresh_bg();
        }

        private function onMouseOver(event:MouseEvent) : void
        {
            draw(16307865, 16774877);
            draw_checkbox();
        }

        private function draw_checkbox(image:Number = 16639160) : void
        {
            checkbox.graphics.clear();
            checkbox.graphics.beginFill(image, 1);
            checkbox.graphics.lineStyle(1, 15658734, 0, true);
            checkbox.graphics.drawRoundRectComplex(0, 0, 20, 20, 4, 4, 4, 4);
            checkbox.graphics.endFill();
        }

    }
}
