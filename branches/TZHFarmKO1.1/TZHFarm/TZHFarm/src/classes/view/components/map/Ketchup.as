package classes.view.components.map
{
    import classes.utils.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    public class Ketchup extends Processor
    {
        private var work_anim_started:Boolean = false;
        private var work_anim_loop:Array;
        private var work_player:TimelinePlayer;
        private var work_anim_ended:Boolean = false;
        private var work_anim_end:Array;
        private var prep_ketchup_interval:Number;
        private var work_anim:Array;

        public function Ketchup(value:Object)
        {
            work_anim = [[1, 18], [19, 26, 5], [27, 53]];
            work_anim_loop = [[40, 53]];
            work_anim_end = [[54, 77]];
            product_mc = "ketchup";
            food_mc = "tomatoes";
            work_player = new TimelinePlayer();
            work_player.addEventListener(TimelinePlayer.FINISH, workFinished);
            super(value);
        }

        override protected function get refill_area() : MovieClip
        {
            if (!mc)
            {
                return null;
            }
            return mc.barrel_anim;
        }

        private function prepare_ketchup_anim() : void
        {
            work_anim_ended = true;
            work_player.stop(false);
            work_player.play(work_anim_end);
            return;
        }

        override protected function get collect_area() : MovieClip
        {
            if (!mc)
            {
                return null;
            }
            return mc.ketchup;
        }

        override protected function startTimer() : void
        {
            var _loc_1:Number = NaN;
            super.startTimer();
            if (next_stage_in() > 0)
            {
                _loc_1 = next_stage_in() * 1000 - 750;
                if (_loc_1 < 10)
                {
                    prepare_ketchup_anim();
                }
                else
                {
                    clearTimeout(prep_ketchup_interval);
                    prep_ketchup_interval = setTimeout(prepare_ketchup_anim, _loc_1);
                    if (!is_updating)
                    {
                        work_player.play(work_anim);
                        work_anim_ended = false;
                    }
                }
            }
            return;
        }

        override protected function disabled_state() : void
        {
            if (mc)
            {
            }
            return;
        }

        override protected function init_asset() : void
        {
            work_player.set_mc(mc.working, mc.barrel_anim, mc.funnel_anim);
            super.init_asset();
            return;
        }

        override protected function hungry_animation() : void
        {
            if (mc)
            {
            }
            return;
        }

        override protected function get collect_hit_area() : MovieClip
        {
            if (!mc)
            {
                return null;
            }
            return mc.ketchup_hit_area;
        }

        private function workFinished(event:Event) : void
        {
            if (is_working)
            {
                if (!work_anim_ended)
                {
                    work_player.play(work_anim_loop);
                }
            }
            else
            {
                work_anim_ended = false;
            }
        }

        override protected function working_animation() : void
        {
            if (mc)
            {
            }
            return;
        }

    }
}
