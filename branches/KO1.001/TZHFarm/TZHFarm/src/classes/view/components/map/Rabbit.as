package classes.view.components.map
{
    import classes.utils.*;
    import classes.view.components.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    public class Rabbit extends Processor
    {
        private var normal_position:Array;
        private var sniff_anim:Array;
        private var wooly_eat_anim:Array;
        private var beg_for_food_interval:Number;
        private var eat_anim:Array;
        private var last_played:String;
        private var wooly_position:Array;
        private var hair_grown:Boolean = false;
        private var rabbit_player:TimelinePlayer;
        private var shear_loader:ProcessLoader;
        private var grow_hair_interval:Number;
        private var wooly_head_turn:Array;
        private var shear_interval:Number;
        private var was_updated:Boolean = false;
        private var head_turn:Array;

        public function Rabbit(value:Object)
        {
            eat_anim = [[2, 11]];
            sniff_anim = [[12, 15], [14, 16, 1], [16, 12], -300];
            wooly_head_turn = [[22, 31]];
            head_turn = [[32, 41], -1000, [41, 32]];
            wooly_eat_anim = [[42, 51]];
            wooly_position = [22];
            normal_position = [1];
            product_mc = "fur";
            food_mc = "carrots";
            rabbit_player = new TimelinePlayer();
            rabbit_player.addEventListener(TimelinePlayer.FINISH, animFinish);
            shear_loader = new ProcessLoader();
            shear_loader.addEventListener(shear_loader.COMPLETE, shearComplete);
            shear_loader.visible = false;
            super(value);
            addChild(shear_loader);
        }

        override protected function startTimer() : void
        {
            var _loc_1:Number = NaN;
            var _loc_2:Number = NaN;
            super.startTimer();
            if (next_stage_in() > 0)
            {
                _loc_1 = start_time + collect_in / 2 - Algo.time();
                if (_loc_1 <= 0)
                {
                    grow_hair();
                }
                else
                {
                    rabbit_player.play(sniff_anim);
                    last_played = "sniff";
                    grow_hair_interval = setTimeout(grow_hair, _loc_1 * 1000);
                }
                _loc_2 = next_stage_in() * 1000 - 5000;
                if (_loc_2 > 0)
                {
                    shear_interval = setTimeout(shear, _loc_2);
                }
                else
                {
                    shear(-_loc_2);
                }
            }
        }

        override protected function init_asset() : void
        {
            rabbit_player.set_mc(mc.rabbit);
            check_begging();
        }

        private function animFinish(event:Event) : void
        {
            if (is_working)
            {
                switch(last_played)
                {
                    case "head_turn_no_carrots":
                    case "beg_for_food":
                    case "hairless_eat":
                    case "sniff":
                    {
                        rabbit_player.play(eat_anim);
                        last_played = "hairless_eat";
                        break;
                    }
                    case "hairfull_eat":
                    {
                        rabbit_player.play(wooly_eat_anim);
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

        override protected function disabled_state() : void
        {
            return;
        }

        override protected function get collect_area() : MovieClip
        {
            if (!mc)
            {
                return null;
            }
            return mc.fur;
        }

        override protected function hungry_animation() : void
        {
            return;
        }

        private function grow_hair() : void
        {
            var _loc_1:Array = null;
            hair_grown = true;
            if (is_working)
            {
                rabbit_player.stop(false);
                if (mc)
                {
                    _loc_1 = [[mc.rabbit.currentFrame + 40, 51]];
                    rabbit_player.play(_loc_1);
                }
                else
                {
                    rabbit_player.play(wooly_eat_anim);
                }
                last_played = "hairfull_eat";
            }
        }

        override public function feed() : void
        {
            super.feed();
            clearTimeout(beg_for_food_interval);
        }

        override protected function get collect_hit_area() : MovieClip
        {
            if (!mc)
            {
                return null;
            }
            return mc.fur_hit_area;
        }

        override public function wait_to_process(value:String) : void
        {
            super.wait_to_process(value);
            if (value == "feed")
            {
                clearTimeout(beg_for_food_interval);
            }
        }

        override public function collect() : void
        {
            if (raw_materials == 0 && products > 0)
            {
                if (last_played != "head_turn_no_carrots")
                {
                    rabbit_player.play(head_turn);
                    last_played = "head_turn_no_carrots";
                }
            }
            super.collect();
        }

        private function shearComplete(event:Event) : void
        {
            hair_grown = false;
            rabbit_player.play(normal_position);
            last_played = "normal_position";
            if (raw_materials > 1)
            {
                if (products < max_products--)
                {
                    rabbit_player.play(sniff_anim, true, 500);
                    last_played = "sniff";
                }
                else
                {
                    rabbit_player.play(head_turn, true, 1000);
                    last_played = "shear_head_turn";
                }
            }
            else
            {
                rabbit_player.play(sniff_anim, true, 500);
                rabbit_player.play(head_turn);
                last_played = "head_turn";
                check_begging();
            }
            shear_loader.visible = false;
            super.on_product_complete();
        }

        override public function update(value:Object) : void
        {
            stopTimer();
            clearTimeout(shear_interval);
            clearTimeout(beg_for_food_interval);
            clearTimeout(grow_hair_interval);
            start_time = value.start_time;
            was_updated = true;
            startTimer();
        }

        override public function kill() : void
        {
            rabbit_player.stop(false);
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
            rabbit_player.stop(false);
            rabbit_player.play(wooly_position);
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
            return mc.carrots;
        }

        private function beg_for_food() : void
        {
            rabbit_player.play(sniff_anim, true, 500);
            rabbit_player.play(head_turn);
            last_played = "beg_for_food";
            check_begging();
        }

    }
}
