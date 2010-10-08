package classes.view.components.map
{
    import classes.utils.*;
    
    import flash.display.*;
    import flash.events.*;

    public class Cow extends Processor
    {
        private var static_pos:Array;
        private var chew_anim:Array;// 吃东西的动画
        private var chew_player:TimelinePlayer;
        private var tail_anim:Array;// 尾巴的动画
        private var tail_player:TimelinePlayer;

        public function Cow(value:Object)
        {
            chew_anim = [[2, 19]];//吃的动作,就是mc里动物的动作的帧
            static_pos = [[TimelinePlayer.CURRENT_FRAME, 19], 1];
            tail_anim = [[1, 21]];
            product_mc = "milk";
            food_mc = "clover";
            tail_player = new TimelinePlayer();
            chew_player = new TimelinePlayer();
            tail_player.addEventListener(TimelinePlayer.FINISH, tailFinish);
            chew_player.addEventListener(TimelinePlayer.FINISH, chewFinish);
            super(value);
        }

        override protected function hungry_animation() : void
        {
            if (mc)
            {
                chew_player.stop(false);
                chew_player.play([1]);
            }
        }

        override protected function get collect_area() : MovieClip
        {
            if (!mc)
            {
                return null;
            }
            return mc.milk;
        }

        private function tailFinish(event:Event) : void
        {
            if (is_working)
            {
                tail_player.play(tail_anim);
            }
        }

        override protected function disabled_state() : void
        {
            if (mc)
            {
            }
            return;
        }

        private function chewFinish(event:Event) : void
        {
            if (is_working)
            {
                chew_player.play(chew_anim);
            }
        }

        override protected function get collect_hit_area() : MovieClip
        {
            if (!mc)
            {
                return null;
            }
            return mc.milk_hit_area;
        }

        override protected function working_animation() : void
        {
            if (mc)
            {
                chew_player.play(chew_anim);
            }
        }

        override protected function init_asset() : void
        {
            chew_player.set_mc(mc.cow);
            super.init_asset();
        }

        override protected function get refill_area() : MovieClip
        {
            if (!mc)
            {
                return null;
            }
            return mc.clover;
        }

    }
}
