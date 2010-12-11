package classes.view.components.map
{
	import classes.utils.Algo;
	import classes.utils.TimelinePlayer;
	import classes.view.components.ProcessLoader;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout; 
	/* import flash.utils.clearTimeout;
	import flash.utils.setTimeout; */
	
	/**
	 * 标签里的动作要分清楚 look up 就只需要look up的内容
	 * 
	 * 抬头时,应该只有向上抬的动画就行了,其它的不需要,因为程序会把动作反转回来,这个过程就做完了
	 * 
	 * 
	 * 第一个标签应该是:静止的状态
	 * 
	 */ 
	public class Peacock extends Processor
	{
		private var normal_position:Array;

		private var eat_anim:Array;
	
		private var peacock_player:TimelinePlayer;
		
		private var last_played:String;
		
		private var beg_for_food_interval:uint;
		
		private var head_turn:Array;
		
		private var was_updated:Boolean;
		
		private var apeacock_position:Array;
		
		public static const NAME:String = "peacock";
		
		private var apeacock_interval:uint;
		
		private var peacock_loader:ProcessLoader;
		
		public function Peacock(value:Object)
		{
			eat_anim = [[2,9],[10, 25],-2000,[25,10]];
			head_turn = [[26, 45], -1000, [45, 26]];
			normal_position = [1];
			apeacock_position = [[46,81],-1000,[81,46]];
			product_mc = "feather";// 
            food_mc = "rice";
			peacock_player = new TimelinePlayer();
            peacock_player.addEventListener(TimelinePlayer.FINISH, animFinish);
            peacock_loader = new ProcessLoader();
            peacock_loader.addEventListener(peacock_loader.COMPLETE, peacockComplete);
            peacock_loader.visible = false;
			super(value);
			addChild(peacock_loader);
		}
		
		override public function wait_to_process(value:String) : void
        {
            super.wait_to_process(value);
            if (value == "feed")// 等待
            {
                clearTimeout(beg_for_food_interval);
            }
        }
        
        /**
         * 喂食 
         */ 
        override public function feed() : void
        {
            super.feed();
            clearTimeout(beg_for_food_interval);
        }
        
        /**
         * 填充材料的 
         */ 
        override protected function get refill_area() : MovieClip
        {
            if (!mc)
            {
                return null;
            }
            return mc.rice;
        }
        
        override protected function get collect_hit_area() : MovieClip
        {
            if (!mc)
            {
                return null;
            }
            return mc.feather_hit_area;
        }
        
        override protected function get collect_area() : MovieClip
        {
            if (!mc)
            {
                return null;
            }
            return mc.feather;
        }
		
		private function animFinish(event:Event) : void
        {
            if (is_working)
            {
                switch(last_played)
                {
                    case "beg_for_food":
                    case "eat":
                    {
                        peacock_player.play(eat_anim);
                        last_played = "eat";
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
        }
        
        private function peacockComplete(event:Event):void {
            peacock_player.play(normal_position);
            last_played = "normal_position";
            if (raw_materials > 1)
            {
            	var temp:int = max_products - 1;
                if (products < temp)
                {
                    peacock_player.play(eat_anim, true, 500);
                    last_played = "eat";
                }
                else
                {
                    peacock_player.play(head_turn, true, 1000);
                    last_played = "head_turn";
                }
            }
            else
            {
                peacock_player.play(head_turn, true, 500);
                last_played = "head_turn";
                check_begging();
            }
            peacock_loader.visible = false;
            super.on_product_complete();
        }
        
        override protected function on_product_complete() : void
        {
            return;
        }
        
        override public function kill() : void
        {
            peacock_player.stop(false);
            super.kill();
        }
        
        override protected function startTimer():void {
        	var t1:Number = NaN;
            var t2:Number = NaN;
            super.startTimer();
            if (next_stage_in() > 0)
            {
            	t1 = start_time + collect_in / 2 - Algo.time();
                if (t1 <= 0)
                {
                }
                else
                {
                    peacock_player.play(eat_anim);
                	last_played = "eat";
                }
                t2 = next_stage_in() * 1000 - 5000;
                if (t2 > 0)
                {
                    apeacock_interval = setTimeout(apeacock, t2);
                }
                else
                {
                    apeacock(-t2);
                }
            }
        }
        
        private function apeacock(value:Number = 0):void {
        	var obj:Object = new Object();
            obj.action = "Shearing";
            obj.delay = 5;
            obj.delay_offset = value / 1000;
            peacock_loader.start(obj, false);
            peacock_loader.x = 0;
            peacock_loader.y = 0;
            peacock_loader.visible = true;
            peacock_player.stop(false);
            peacock_player.play(apeacock_position);
            last_played = "apeacock_position";
        }
        
        override protected function init_asset() : void
        {
            peacock_player.set_mc(mc.peacock);
            check_begging();// 如果没有食物的话,回回头
            if (!is_working)
            {
                peacock_player.play(normal_position);
            }
        }
        
        /**
         * 收获时 
         */ 
        override public function collect() : void
        {
            if (raw_materials == 0 && products > 0)
            {
                if (last_played != "head_turn")
                {
                    peacock_player.play(head_turn);
                    last_played = "head_turn";
                }
            }
            super.collect();
        }
        
        override public function update(value:Object) : void
        {
            stopTimer();
            clearTimeout(apeacock_interval);
            clearTimeout(beg_for_food_interval);
            start_time = value.start_time;
            was_updated = true;
            startTimer();
        }
        
        private function check_begging() : void
        {
            if (!raw_materials)
            {
                clearTimeout(beg_for_food_interval);
                beg_for_food_interval = setTimeout(beg_for_food, Algo.rand(25, 90) * 1000);
            }
        }
        
        private function beg_for_food() : void
        {
            peacock_player.play(head_turn, true, 500);
            last_played = "beg_for_food";
            check_begging();
        }
	}
}