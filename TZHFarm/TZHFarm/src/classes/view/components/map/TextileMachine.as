package classes.view.components.map
{
    import classes.utils.*;
    import flash.events.*;

    public class TextileMachine extends MultiProcessor
    {
        private var wool_player:TimelinePlayer;
        private var anim_end:Array;
        private var anim_player:TimelinePlayer;
        private var wool_anim:Array;
        private var work_anim:Array;

        public function TextileMachine(value:Object)
        {
            wool_anim = [[2, 8]];
            work_anim = [[1, 19]];
            anim_end = [[1]];
            wool_player = new TimelinePlayer();
            anim_player = new TimelinePlayer();
            wool_player.addEventListener(TimelinePlayer.FINISH, woolFinished);
            anim_player.addEventListener(TimelinePlayer.FINISH, animFinished);
            super(value);
        }

        override protected function init_asset() : void
        {
            wool_player.set_mc(mc.wool);
            anim_player.set_mc(mc.anim);
            super.init_asset();
        }

        private function animFinished(event:Event) : void
        {
            if (next_product_in() > 0)
            {
                anim_player.play(work_anim);
            }
            else
            {
                anim_player.play(anim_end, false);
            }
        }

        private function woolFinished(event:Event) : void
        {
            if (next_product_in() > 0)
            {
                wool_player.play(wool_anim);
            }
            else
            {
                wool_player.play(anim_end, false);
            }
        }

        override protected function start_anim() : void
        {
            wool_player.play(wool_anim);
            anim_player.play(work_anim);
        }

    }
}
