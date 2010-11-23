package classes.view.components.popups
{
    import classes.utils.*;
    
    import flash.display.*;
    import flash.events.*;
    
    import mx.resources.ResourceManager;

    public class StoryPopup extends DynamicPopup
    {
        private var data:Object;
        private var bmp:Bitmap;

        public function StoryPopup(value:Object)
        {
            this.data = value;
            super(564, 462, 428, 308, value.message);
        }

        override protected function init() : void
        {
            ok_label = ResourceManager.getInstance().getString("message","game_button_accpet_message");
            close_label = ResourceManager.getInstance().getString("message","game_button_ignore_message");
            inner_cont_padd = 62;
            inner_cont_padd_w = 0;
            align_tf = false;
            tf_padd_h = 10;
            bg_scale = 1.35;
            super.init();
            ok_btn.set_text_size(22);
            close_btn.set_text_size(22);
            var cache:Cache = new Cache();
            cache.addEventListener(Cache.LOAD_COMPLETE, onLoadComplete);
            cache.load(data.image);
        }

        public function get feed_data() : Object
        {
            return data.feed_data;
        }

        override protected function draw() : void
        {
            super.draw();
            alignButtons();
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
        }

        private function onLoadComplete(event:Event) : void
        {
            bmp = event.target.asset as Bitmap;
            content.addChild(bmp);
            alignButtons();
        }

    }
}
