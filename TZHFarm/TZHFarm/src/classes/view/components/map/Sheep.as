package classes.view.components.map
{
    import classes.utils.*;
    import classes.view.components.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    public class Sheep extends Processor
    {
        private var normal_position:Array;// 正常的显示的状态
        private var wooly_eat_anim:Array;// 有羊毛时吃东西的状态
        private var beg_for_food_interval:Number;
        private var eat_anim:Array;// 吃东西的状态
        private var last_played:String;
        private var wooly_position:Array;// 有羊毛的位置
        private var hair_grown:Boolean = false;
        private var hopping_anim:Array;// 高兴的
        private var shear_loader:ProcessLoader;
        private var sheep_player:TimelinePlayer;
        private var grow_hair_interval:Number;
        private var wooly_head_turn:Array;// 有羊毛的转身
        private var shear_interval:Number;
        private var was_updated:Boolean = false;
        private var head_turn:Array;// 转向

        public function Sheep(value:Object)
        {
            eat_anim = [[1, 13]];
            hopping_anim = [[27, 53], -300];
            wooly_head_turn = [[63, 71]];
            head_turn = [[54, 62], -1000, [61, 54]];
            wooly_eat_anim = [[14, 26]];
            wooly_position = [63];
            normal_position = [27];
            product_mc = "wool";
            food_mc = "wheat";
            sheep_player = new TimelinePlayer();
            sheep_player.addEventListener(TimelinePlayer.FINISH, animFinish);
            shear_loader = new ProcessLoader();
            shear_loader.addEventListener(shear_loader.COMPLETE, shearComplete);
            shear_loader.visible = false;
            super(value);
            addChild(shear_loader);
        }

        override protected function startTimer() : void
        {
            var t1:Number = NaN;
            var t2:Number = NaN;
            super.startTimer();
            if (next_stage_in() > 0)
            {
                t1 = start_time + collect_in / 2 - Algo.time();
                if (t1 <= 0)
                {
                    grow_hair();
                }
                else
                {
                    sheep_player.play(eat_anim);
                    last_played = "hairless_eat";
                    grow_hair_interval = setTimeout(grow_hair, t1 * 1000);
                }
                t2 = next_stage_in() * 1000 - 5000;
                if (t2 > 0)
                {
                    shear_interval = setTimeout(shear, t2);
                }
                else
                {
                    shear(-t2);
                }
            }
        }

        private function animFinish(event:Event) : void
        {
            if (is_working)
            {
                switch(last_played)
                {
                    case "head_turn_no_wheat":
                    case "beg_for_food":
                    case "hairless_eat":
                    {
                        sheep_player.play(eat_anim);
                        last_played = "hairless_eat";
                        break;
                    }
                    case "hairfull_eat":
                    {
                        sheep_player.play(wooly_eat_anim);
                        last_played = "hairfull_eat";
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
        }

        override protected function init_asset() : void
        {
            sheep_player.set_mc(mc.sheep);
            check_begging();
            if (!is_working)
            {
                sheep_player.play(normal_position);
            }
        }

        override protected function get collect_area() : MovieClip
        {
            if (!mc)
            {
                return null;
            }
            return mc.wool;
        }

        override protected function disabled_state() : void
        {
            return;
        }

        override protected function hungry_animation() : void
        {
            return;
        }

        private function grow_hair() : void
        {
            var frames:Array = null;
            hair_grown = true;
            if (is_working)
            {
                sheep_player.stop(false);
                if (mc)
                {
                    frames = [[mc.sheep.currentFrame + 13, 26]];
                    sheep_player.play(frames);
                }
                else
                {
                    sheep_player.play(wooly_eat_anim);
                }
                last_played = "hairfull_eat";
            }
        }

        override public function feed() : void
        {
            super.feed();
            clearTimeout(beg_for_food_interval);
        }

        override public function collect() : void
        {
            if (raw_materials == 0 && products > 0)
            {
                if (last_played != "head_turn_no_wheat")
                {
                    sheep_player.play(head_turn);
                    last_played = "head_turn_no_wheat";
                }
            }
            super.collect();
        }

        override protected function get collect_hit_area() : MovieClip
        {
            if (!mc)
            {
                return null;
            }
            return mc.wool_hit_area;
        }

        override public function wait_to_process(value:String) : void
        {
            super.wait_to_process(value);
            if (value == "feed")
            {
                clearTimeout(beg_for_food_interval);
            }
        }

        private function shearComplete(event:Event) : void
        {
            hair_grown = false;
            sheep_player.play(normal_position);
            last_played = "normal_position";
            if (raw_materials > 1)
            {
            	var temp:int = max_products - 1;
                if (products < temp)
                {
                    sheep_player.play(eat_anim, true, 500);
                    last_played = "hairless_eat";
                }
                else
                {
                    sheep_player.play(head_turn, true, 1000);
                    last_played = "shear_head_turn";
                }
            }
            else
            {
                sheep_player.play(head_turn, true, 500);
                last_played = "head_turn";
                check_begging();
            }
            shear_loader.visible = false;
            super.on_product_complete();
        }

        override public function update(shearComplete:Object) : void
        {
            stopTimer();
            clearTimeout(shear_interval);
            clearTimeout(beg_for_food_interval);
            clearTimeout(grow_hair_interval);
            start_time = shearComplete.start_time;
            was_updated = true;
            startTimer();
        }

        override public function kill() : void
        {
            sheep_player.stop(false);
            super.kill();
        }

        private function shear(value:Number = 0):void
        {
            var obj:Object = new Object();
            obj.action = "Shearing";
            obj.delay = 5;
            obj.delay_offset = value / 1000;
            shear_loader.start(obj, false);
            shear_loader.x = 0;
            shear_loader.y = 0;
            shear_loader.visible = true;
            sheep_player.stop(false);
            sheep_player.play(wooly_position);
            last_played = "wooly_position";
        }

        override protected function on_product_complete() : void
        {
            return;
        }

        private function check_begging() : void
        {
            if (!raw_materials)
            {
                clearTimeout(beg_for_food_interval);
                beg_for_food_interval = setTimeout(beg_for_food, Algo.rand(25, 90) * 1000);
            }
        }

        override protected function working_animation() : void
        {
            return;
        }

        override protected function get refill_area() : MovieClip
        {
            if (!mc)
            {
                return null;
            }
            return mc.wheat;
        }

        private function beg_for_food() : void
        {
            sheep_player.play(head_turn, true, 500);
            last_played = "beg_for_food";
            check_begging();
        }

    }
}
