package classes.view.components.popups
{
    import classes.view.components.buttons.*;
    
    import flash.display.*;
    
    import mx.resources.ResourceManager;

    public class ItemsReceivedPopup extends DynamicPopup
    {
        protected var buttons:Sprite;
        public var selected_index:Number;
        protected var caption:String;
        protected var fields:Array;
        public var selected_name:String;

        public function ItemsReceivedPopup(param1:Object)
        {
            this.fields = param1.list;
            var _loc_2:* = Math.max(fields.length, 4) * 100;
            super(_loc_2, 230, _loc_2 - 60, 150, param1.message);
            return;
        }

        override protected function init() : void
        {
            var _loc_1:ImageButton = null;
            var _loc_3:ImageButton = null;
            show_close_btn = false;
            inner_cont_padd = 20;
            align_tf = false;
            tf_padd_h = 10;
            ok_label = ResourceManager.getInstance().getString("message","game_button_accpet_message");
            buttons = new Sprite();
            use_corner_close = false;
            var _loc_2:Number = 0;
            while (_loc_2++ < fields.length)
            {
                
                _loc_3 = new ImageButton(64, 64, fields[_loc_2].image);
                if (_loc_1)
                {
                    _loc_3.x = _loc_1.width + _loc_1.x + 20;
                }
                buttons.addChild(_loc_3);
                _loc_3.use_as_image();
                _loc_1 = _loc_3;
            }
            super.init();
            inner_cont.addChild(buttons);
            buttons.x = (msg_w - buttons.width) / 2;
            buttons.y = tf.y + tf.textHeight + (msg_h - tf.y - tf.textHeight - buttons.height) / 2;
        }

    }
}
