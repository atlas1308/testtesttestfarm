package classes.view.components.map
{
    import classes.utils.*;
    import classes.view.components.*;
    
    import mx.resources.ResourceManager;

    public class Fertilizer extends MapObject
    {
        protected var _percent:Number;
        protected var times_used:Number;
        protected var tip:Confirmation;
        protected var _area_x:Number;
        protected var _area_y:Number;
        protected var _uses:Number;
        protected var _cursor_url:String;

        public function Fertilizer(value:Object) : void
        {
            super(value);
            _uses = value.uses;
            times_used = value.times_used ? (value.times_used) : (0);
            _area_x = value.area_x;
            _area_y = value.area_y;
            _percent = value.percent;
            _cursor_url = "images/" + value.url + "_cur.png";
        }

        override protected function init_asset() : void
        {
            update_value();
        }

        public function clear_highlight() : void
        {
            if (mc)
            {
                Effects.clear(mc.sack);
            }
        }

        public function get percent() : Number
        {
            return _percent;
        }

        public function get area_y() : Number
        {
            return _area_y;
        }

        public function get area_x() : Number
        {
            return _area_x;
        }

        override protected function init() : void
        {
            super.init();
            loader.cache_swf = true;
        }

        public function get cursor_url() : String
        {
            return _cursor_url;
        }

        public function can_use(value:Number = 1) : Boolean
        {
            if (times_used + value > _uses)
            {
                return false;
            }
            return true;
        }

        public function show_tip() : void
        {
            var obj:Object = null;
            if (!tip)
            {
                obj = new Object();
                obj.minus = ResourceManager.getInstance().getString("message","fertilizer_minus_message");
                obj.target = {x:0, y:_height};
                obj.duration = 1;
                tip = new Confirmation(obj);
                addChild(tip);
            }
        }

        public function get uses_left() : Number
        {
            return _uses - times_used;
        }

        public function hide_tip() : void
        {
            if (tip)
            {
                tip.start();
            }
        }

        public function highlight_sack() : void
        {
            if (mc)
            {
                Effects.glow(mc.sack);
            }
        }

        public function use_it(obj:Number = 1) : void
        {
            times_used = times_used + obj;
            update_value();
        }

        private function update_value() : void
        {
            if (mc)
            {
                mc.value.text = String(_uses - times_used);
            }
        }

    }
}
