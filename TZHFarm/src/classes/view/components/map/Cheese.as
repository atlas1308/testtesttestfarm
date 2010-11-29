package classes.view.components.map
{
    import classes.utils.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
	
	/**
	 * 乳酪，干酪的生产器
	 */ 
    public class Cheese extends Processor
    {
        private var work_anim_started:Boolean = false;
        private var milk_player:TimelinePlayer;
        private var work_player:TimelinePlayer;
        private var prep_cheese_interval:Number;
        private var work_anim_end:Array;
        private var work_anim_loop:Array;
        private var work_anim_ended:Boolean = false;
        private var work_anim:Array;

        public function Cheese(value:Object)
        {
            work_anim = [[1, 12], [13, 33], [34, 38, 7]];
            work_anim_loop = [[13, 33], [34, 38, 7]];
            work_anim_end = [[39, 50]];
            product_mc = "cheese";
            work_player = new TimelinePlayer();
            milk_player = new TimelinePlayer();
            work_player.addEventListener(TimelinePlayer.FINISH, workFinished);
            super(value);
        }

        override protected function startTimer() : void
        {
            var diff:int = 0;
            super.startTimer();
            if (next_stage_in() > 0)
            {
                diff = next_stage_in() * 1000 - 500;
                if (diff > 10)
                {
                    clearTimeout(prep_cheese_interval);
                    prep_cheese_interval = setTimeout(prepare_cheese_anim, diff);
                }
                else
                {
                    prepare_cheese_anim();
                }
            }
        }

        override protected function queue_highlight() : void
        {
            super.queue_highlight();
            if (!mc)
            {
                return;
            }
            if (process_count["feed"] > 0)
            {
                mc.milk_levels.visible = true;
                mc.milk_levels.gotoAndStop(process_count["feed"] + raw_materials);
                mc.milk_levels.alpha = 0.2;
                Effects.green(mc.milk_levels);
            }
        }

        override public function process() : void
        {
            if (process_count["feed"] >= 1)
            {
                milk_player.play([[TimelinePlayer.CURRENT_FRAME, raw_materials * 10]]);
            }
            super.process();
        }

        override protected function get collect_area() : MovieClip
        {
            if (!mc)
            {
                return null;
            }
            return mc.cheese;
        }

        override protected function disabled_state() : void
        {
            if (mc)
            {
            }
        }

        override protected function init_asset() : void
        {
            mc.milk_levels.visible = false;
            milk_player.set_mc(mc.milk);
            work_player.set_mc(mc.working, mc.pipe_anim);
            super.init_asset();
        }

        override protected function hungry_animation() : void
        {
            if (mc)
            {
            }
        }

        override protected function update_raw_material_area() : void
        {
            if (!mc)
            {
                return;
            }
            Effects.clear(mc.milk);
            if (!process_count["feed"])
            {
                mc.milk_levels.visible = false;
                if (raw_materials > 0)
                {
                    milk_player.play([[TimelinePlayer.CURRENT_FRAME, raw_materials * 10]]);
                }
                else
                {
                    milk_player.play([[TimelinePlayer.CURRENT_FRAME, 1]]);
                }
            }
            queue_highlight();
        }

        private function prepare_cheese_anim() : void
        {
            work_anim_ended = true;
            work_player.stop(false);
            work_player.play(work_anim_end);
        }

        private function workFinished(event:Event) : void
        {
            if (is_working)
            {
                work_player.play(work_anim_loop);
            }
            else
            {
                work_anim_started = false;
                work_anim_ended = false;
            }
            return;
        }

        override protected function get collect_hit_area() : MovieClip
        {
            if (!mc)
            {
                return null;
            }
            return mc.cheese_hit_area;
        }

        override protected function get refill_area() : MovieClip
        {
            if (!mc)
            {
                return null;
            }
            return mc.milk_container;
        }

        override protected function working_animation() : void
        {
            if (mc)
            {
                if (!work_anim_started)
                {
                    work_player.play(work_anim);
                    work_anim_started = true;
                }
                else if (!work_anim_ended)
                {
                    work_player.play(work_anim_loop);
                }
            }
        }

    }
}
