package classes.view.components.map
{
    import classes.utils.*;
    import flash.events.*;

    public class MultiMill extends MultiProcessor
    {
        private var finish_anim_flipped:Array;
        private var finish_anim_normal:Array;
        private var anim_end:Boolean = false;
        private var anim_flipped:Array;
        private var anim_normal:Array;
        private var sails_player:TimelinePlayer;

        public function MultiMill(param1:Object)
        {
            anim_normal = [[1, 19]];
            finish_anim_normal = [[TimelinePlayer.CURRENT_FRAME, 19], 1];
            anim_flipped = [[19, 1]];
            finish_anim_flipped = [[TimelinePlayer.CURRENT_FRAME, 1]];
            sails_player = new TimelinePlayer();
            sails_player.addEventListener(TimelinePlayer.FINISH, animFinish);
            super(param1);
            return;
        }

        override protected function init_asset() : void
        {
            if (!under_construction)
            {
                sails_player.set_mc(mc.sails);
            }
            super.init_asset();
            return;
        }

        override protected function update_product_area() : void
        {
            super.update_product_area();
            if (!mc)
            {
                return;
            }
            mc.product_shadow.visible = products.length > 0;
            return;
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
            return;
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

        override protected function start_anim() : void
        {
            if (!sails_player.is_playing())
            {
                sails_player.play(anim);
            }
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
