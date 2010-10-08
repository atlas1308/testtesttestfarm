package classes.view.components.map
{
    import classes.utils.*;
    
    import flash.display.*;
    import flash.events.*;

    public class Hive extends Processor
    {
        public static const FLY:String = "fly";
        private var bees_are_out:Boolean = false;
        public const BEES_ARE_OUT:String = "beesAreOut";
        private var last_played:String;
        private var out_anim:Array;
        private var in_anim:Array;
        private var bees_player:TimelinePlayer;
        public var bee2:MovieClip;
        public var bee3:MovieClip;
        public var bee1:MovieClip;

        public function Hive(value:Object)
        {
            out_anim = [[1, 52]];
            in_anim = [[53, 104]];
            bees_player = new TimelinePlayer();
            bees_player.addEventListener(TimelinePlayer.FINISH, animFinish);
            product_mc = "honey";
            super(value);
        }

        override public function kill() : void
        {
            bees_player.stop(false);
            bees_player.removeEventListener(TimelinePlayer.FINISH, animFinish);
            super.kill();
        }

        override protected function init_asset() : void
        {
            mc.bee1.gotoAndStop(1);
            mc.bee2.gotoAndStop(1);
            mc.bee3.gotoAndStop(1);
            mc.bee1.visible = false;
            mc.bee2.visible = false;
            mc.bee3.visible = false;
            bee1 = mc.bee1;
            bee2 = mc.bee2;
            bee3 = mc.bee3;
            bees_player.set_mc(mc.bees);
            initialize();
            super.init_asset();
        }

        override protected function get collect_area() : MovieClip
        {
            if (!mc)
            {
                return null;
            }
            return mc.honey;
        }

        public function goOut() : void
        {
            bees_are_out = true;
            bees_player.play(out_anim);
            last_played = "out_anim";
        }

        override public function update(value:Object) : void
        {
            return;
        }

        private function animFinish(event:Event) : void
        {
            switch(last_played)
            {
                case "out_anim":
                {
                    mc.bees.visible = false;
                    dispatchEvent(new Event(BEES_ARE_OUT));
                    break;
                }
                case "in_anim":
                {
                    super.feed();
                    bees_are_out = false;
                    break;
                }
                case "in_anim_no_clover":
                {
                    bees_are_out = false;
                    break;
                }
                default:
                {
                    break;
                }
            }
        }

        override protected function on_product_complete() : void
        {
            super.on_product_complete();
            if (products < max_products)
            {
                dispatchEvent(new Event(FLY));
            }
        }

        override public function collect() : void
        {
            super.collect();
            this.initialize();
        }

        override protected function disabled_state() : void
        {
            if (mc)
            {
            }
        }

        public function initialize() : void
        {
            if (is_working)
            {
                return;
            }
            if (products == max_products)
            {
                return;
            }
            if (bees_are_out)
            {
                return;
            }
            if (mc)
            {
                dispatchEvent(new Event(FLY));
            }
        }

        override protected function update_raw_material_area() : void
        {
            return;
        }

        public function bees_are_flying() : Boolean
        {
            return bees_are_out;
        }

        override public function can_feed() : Boolean
        {
            return false;
        }

        override protected function get collect_hit_area() : MovieClip
        {
            if (!mc)
            {
                return null;
            }
            return mc.honey_hit_area;
        }

        public function goIn() : void
        {
            if (!mc)
            {
                return;
            }
            mc.bees.visible = true;
            bees_player.play(in_anim);
            last_played = "in_anim_no_clover";
        }

        override protected function get refill_area() : MovieClip
        {
            return null;
        }

        public function make_honey() : void
        {
            if (!mc)
            {
                return;
            }
            mc.bees.visible = true;
            bees_player.play(in_anim);
            last_played = "in_anim";
        }

    }
}
