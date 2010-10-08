package classes.view.components.popups
{
    import classes.utils.*;
    import flash.display.*;
    import flash.events.*;

    public class StoryPopup extends DynamicPopup
    {
        private var data:Object;
        private var bmp:Bitmap;

        public function StoryPopup(param1:Object)
        {
            this.data = param1;
            super(564, 462, 428, 308, param1.message);
            return;
        }

        override protected function init() : void
        {
            ok_label = "Accept";
            close_label = "Ignore";
            inner_cont_padd = 62;
            inner_cont_padd_w = 0;
            align_tf = false;
            tf_padd_h = 10;
            bg_scale = 1.35;
            super.init();
            ok_btn.set_text_size(22);
            close_btn.set_text_size(22);
            var _loc_1:* = new Cache();
            _loc_1.addEventListener(_loc_1.LOAD_COMPLETE, onLoadComplete);
            _loc_1.load(data.image);
            return;
        }

        public function get feed_data() : Object
        {
            return data.feed_data;
        }

        override protected function draw() : void
        {
            super.draw();
            alignButtons();
            return;
        }

        override protected function alignButtons() : void
        {
            super.alignButtons();
            if (!bmp)
            {
                return;
            }
            bmp.x = inner_cont.x + (msg_w - bmp.width) / 2;
            bmp.y = inner_cont.y + (msg_h - bmp.height) - 10;
            return;
        }

        private function onLoadComplete(event:Event) : void
        {
            bmp = event.target.asset as Bitmap;
            content.addChild(bmp);
            alignButtons();
            return;
        }

    }
}
