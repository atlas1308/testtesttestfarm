package classes.view.components.map
{
    import classes.utils.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    public class WineMachine extends Processor
    {
        private var work_anim_started:Boolean = false;
        private var work_player:TimelinePlayer;
        private var wine_player:TimelinePlayer;
        private var work_anim_end:Array;
        private var work_anim_loop:Array;
        private var show_bottle_anim:Array;
        private var prep_wine_interval:Number;
        private var bottles:Number = 0;
        private var work_anim_ended:Boolean = false;
        private var work_anim:Array;

        public function WineMachine(value:Object)
        {
            work_anim = [[1, 96], [97, 120]];// 这和个具体的值我稍后会定义出具体的意思来
            work_anim_loop = [[97, 120]];
            work_anim_end = [[121, 140]];
            show_bottle_anim = [[TimelinePlayer.CURRENT_FRAME, 24]];
            food_mc = "grapes";
            product_mc = "wine";
            work_player = new TimelinePlayer();
            wine_player = new TimelinePlayer();
            work_player.addEventListener(TimelinePlayer.FINISH, workFinished);
            wine_player.addEventListener(TimelinePlayer.FINISH, wineFinished);
            super(value);
        }

        override protected function startTimer() : void
        {
            var _loc_1:* = undefined;
            super.startTimer();
            if (next_stage_in() > 0)
            {
                _loc_1 = next_stage_in() * 1000 - 500;
                if (_loc_1 > 10)
                {
                    clearTimeout(prep_wine_interval);
                    prep_wine_interval = setTimeout(prepare_wine_anim, _loc_1);
                    if (!is_updating)
                    {
                        work_player.play(work_anim);
                        work_anim_ended = false;
                    }
                }
                else
                {
                    prepare_wine_anim();
                }
            }
            return;
        }

        override protected function get refill_area() : MovieClip
        {
            if (!mc)
            {
                return null;
            }
            return mc.glow;
        }

        override protected function get collect_area() : MovieClip
        {
            if (!mc)
            {
                return null;
            }
            return mc.wine;
        }

        override protected function disabled_state() : void
        {
            if (mc)
            {
            }
            return;
        }

        override public function clear_highlight() : void
        {
            super.clear_highlight();
            if (refill_area)
            {
            }
            return;
        }

        override protected function update_product_area() : void
        {
            if (mc)
            {
                mc[product_mc][product_mc + "1"].visible = false;
                mc[product_mc][product_mc + "2"].visible = false;
                mc[product_mc][product_mc + "3"].visible = false;
                if (products >= 1)
                {
                    mc[product_mc][product_mc + "1"].visible = true;
                    wine_player.set_mc(mc[product_mc][product_mc + "1"]);
                    wine_player.play(show_bottle_anim);
                    bottles = 1;
                    Effects.clear(mc[product_mc][product_mc + "1"]);
                }
                else
                {
                    mc[product_mc][product_mc + "1"].gotoAndStop(1);
                    mc[product_mc][product_mc + "2"].gotoAndStop(1);
                    mc[product_mc][product_mc + "3"].gotoAndStop(1);
                }
                if (products >= 2)
                {
                    mc[product_mc][product_mc + "2"].visible = true;
                    Effects.clear(mc[product_mc][product_mc + "2"]);
                }
                else
                {
                    mc[product_mc][product_mc + "2"].gotoAndStop(1);
                    mc[product_mc][product_mc + "3"].gotoAndStop(1);
                }
                if (products >= 3)
                {
                    mc[product_mc][product_mc + "3"].visible = true;
                    Effects.clear(mc[product_mc][product_mc + "3"]);
                }
                else
                {
                    mc[product_mc][product_mc + "3"].gotoAndStop(1);
                }
                queue_highlight();
            }
            return;
        }

        private function prepare_wine_anim() : void
        {
            work_anim_ended = true;
            work_player.stop(false);
            work_player.play(work_anim_end);
            return;
        }

        override protected function hungry_animation() : void
        {
            if (mc)
            {
            }
            return;
        }

        override public function highlight_refill() : void
        {
            clear_highlight();
            if (refill_area)
            {
                Effects.glow(refill_area);
            }
            return;
        }

        private function wineFinished(event:Event) : void
        {
            if (bottles >= products)
            {
                return;
            }
            bottles++;
            if (bottles > 3)
            {
                return;
            }
            if (!mc)
            {
                return;
            }
            mc[product_mc][product_mc + bottles].visible = true;
            wine_player.set_mc(mc[product_mc][product_mc + bottles]);
            wine_player.play(show_bottle_anim);
            return;
        }

        override protected function init_asset() : void
        {
            work_player.set_mc(mc.anim);
            super.init_asset();
            return;
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
            return mc.wine_hit_area;
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
