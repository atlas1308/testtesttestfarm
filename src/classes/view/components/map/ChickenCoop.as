package classes.view.components.map
{
    import classes.utils.*;
    
    import flash.display.*;
    import flash.events.*;

    public class ChickenCoop extends Processor
    {
        private var play_interval:Number;
        private var anim:Array;
        private var head_turn:Array;
        private var chickens:Array;

        public function ChickenCoop(value:Object)
        {
            anim = [[1, 10], [10, 19], 18, 19, 18, 19, [18, 15], -200, [16, 19], 18, 19, [18, 10], -200, 1, [2, 10], -200, 1];
            head_turn = [[TimelinePlayer.CURRENT_FRAME, 1], [20, 23], -500, [22, 20], 1];
            chickens = new Array();
            product_mc = "egg";
            food_mc = "corn";
            super(value);
        }

        override protected function init_asset() : void
        {
            update_animals();
            update_players();
        }

        override public function addAnimal() : void
        {
            super.addAnimal();
            update_players();
        }

        override protected function update_animals() : void
        {
            if (!mc)
            {
                return;
            }
            var index:Number = 1;
            while (index <= 5)
            {
                mc["chicken" + index].visible = index <= animals;
                index++;
            }
        }

        override protected function get collect_area() : MovieClip
        {
            if (!mc)
            {
                return null;
            }
            return mc.egg;
        }

        override protected function startTimer() : void
        {
            super.startTimer();
            if (next_stage_in() > 0 && chickens.length > 0)
            {
                random_chicken().play(anim);
            }
        }

        private function update_players() : void
        {
            var timelinePlayer:TimelinePlayer = null;
            chickens = new Array();
            var index:Number = 1;
            while (index <= animals)
            {
                timelinePlayer = new TimelinePlayer(mc["chicken" + index]);
                timelinePlayer.addEventListener(TimelinePlayer.FINISH, animFinished);
                chickens.push(timelinePlayer);
                index++;
            }
            if (is_working)
            {
                random_chicken().play(anim);
            }
        }

        override protected function disabled_state() : void
        {
            if (mc)
            {
            }
        }

        override protected function hungry_animation() : void
        {
            return;
        }

        override protected function get collect_hit_area() : MovieClip
        {
            if (!mc)
            {
                return null;
            }
            return mc.eggs_hit_area;
        }

        override protected function working_animation() : void
        {
            if (mc)
            {
            }
        }

        private function random_chicken() : TimelinePlayer
        {
        	var index:int = chickens.length - 1;
            var random:int = Math.min(index, int(Math.random() * chickens.length));
            return chickens[random] as TimelinePlayer;
        }

        private function animFinished(event:Event) : void
        {
            var _loc_3:Number = NaN;
            var index:Number = 0;
            while (index < Algo.rand(1, animals))
            {
                
                _loc_3 = is_working ? (Algo.rand(5000, 10000)) : (Algo.rand(20000, 30000));
                if (Algo.rand(0, 1) == 1)
                {
                    random_chicken().play(anim, true, _loc_3);
                    index++;
                    continue;
                }
                random_chicken().play(head_turn, true, _loc_3);
                index++;
            }
        }

        override protected function get refill_area() : MovieClip
        {
            if (!mc)
            {
                return null;
            }
            return mc.corn;
        }

        override protected function update_raw_material_area() : void
        {
            super.update_raw_material_area();
            if (!mc)
            {
                return;
            }
            mc.ground1.visible = false;
            mc.ground2.visible = false;
            mc.ground3.visible = false;
            if (raw_materials > 0)
            {
                mc.ground1.visible = true;
            }
            if (raw_materials > 1)
            {
                mc.ground2.visible = true;
            }
            if (raw_materials > 2)
            {
                mc.ground3.visible = true;
            }
        }
    }
}
