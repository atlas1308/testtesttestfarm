package classes.view.components.map
{
    import classes.utils.*;
    
    import flash.display.*;
    import flash.events.*;

    public class Mill extends Processor
    {
        private var finish_anim_flipped:Array;
        private var anim_flipped:Array;
        private var anim_normal:Array;
        private var sails_player:TimelinePlayer;
        private var finish_anim_normal:Array;
        private var anim_end:Boolean = false;

        public function Mill(value:Object)
        {
            anim_normal = [[1, 19]];
            finish_anim_normal = [[TimelinePlayer.CURRENT_FRAME, 19], 1];
            anim_flipped = [[19, 1]];
            finish_anim_flipped = [[TimelinePlayer.CURRENT_FRAME, 1]];
            product_mc = "flour";
            food_mc = "wheat";
            sails_player = new TimelinePlayer();
            sails_player.addEventListener(TimelinePlayer.FINISH, animFinish);
            super(value);
        }

        override protected function init_asset() : void
        {
            sails_player.set_mc(mc.sails);
        }

        override protected function get collect_area() : MovieClip
        {
            if (!mc)
            {
                return null;
            }
            return mc.flour;
        }

        private function animFinish(event:Event) : void
        {
            if (is_working)
            {
                sails_player.play(anim);
                anim_end = false;
            }
            else if (!anim_end)
            {
                sails_player.play(finish_anim);
                anim_end = true;
            }
            else
            {
                disabled_state();
            }
        }

        override protected function working_animation() : void
        {
            if (mc)
            {
                sails_player.play(anim);
            }
        }

        override protected function disabled_state() : void
        {
            return;
        }

        private function get anim() : Array
        {
            if (asset.scaleX < 0)
            {
                return anim_flipped;
            }
            return anim_normal;
        }

        override protected function update_product_area() : void
        {
            super.update_product_area();
            if (products >= 1 && mc)
            {
                mc.flour1_shadow.visible = true;
            }
            else if (mc)
            {
                mc.flour1_shadow.visible = false;
            }
        }

        override protected function hungry_animation() : void
        {
            if (mc)
            {
                if (is_working)
                {
                    sails_player.play(finish_anim);
                }
            }
        }

        override public function kill() : void
        {
            sails_player.stop(false);
            super.kill();
        }

        override protected function get collect_hit_area() : MovieClip
        {
            if (!mc)
            {
                return null;
            }
            return mc.flour_hit_area;
        }

        override public function flip() : void
        {
            super.flip();
            if (sails_player.is_playing())
            {
                sails_player.stop(false);
                anim_end = false;
                animFinish(null);
            }
            return;
        }

        override protected function get refill_area() : MovieClip
        {
            if (!mc)
            {
                return null;
            }
            return mc.mill_door;
        }

        private function get finish_anim() : Array
        {
            if (asset.scaleX < 0)
            {
                return finish_anim_flipped;
            }
            return finish_anim_normal;
        }

    }
}
