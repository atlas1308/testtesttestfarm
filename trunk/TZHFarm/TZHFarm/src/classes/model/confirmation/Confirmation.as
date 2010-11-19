package classes.model.confirmation {
    import classes.utils.*;
    import classes.view.components.map.*;
    
    import flash.geom.*;
    
    import mx.resources.ResourceManager;
	
	/**
	 * 加钱,经验的效果都在这里操作,就是一个显示的动画
	 */ 
    public class Confirmation {

        private var output:Object;
        public var coins:Number;
        private var target:Object;
        private var plus_text:String = "";
        public var reward_points:Number = 0;
        public var duration:Number = 1.5;
        public var level_up:Boolean = false;
        private var minus_text:String = "";
        public var exp:Number;
        
        /**
         * 
         */ 
        public function Confirmation(exp:Number=0, coins:Number=0, reward_points:Number=0){
            super();
            this.exp = exp;
            this.coins = coins;
            this.reward_points = reward_points;
            add_value(exp, " " + ResourceManager.getInstance().getString("message","xp_message"));
            add_value(coins, " " + ResourceManager.getInstance().getString("message","coins_message"));
            add_value(reward_points, " " + ResourceManager.getInstance().getString("message","ranch_cash_message"));
        }
        
        public function get_data():Object{
            output = new Object();
            output.plus = plus_text;
            output.minus = minus_text;
            output.duration = duration;
            output.target = target;
            return output;
        }
        
        public function add_rp(v:Number):void{
            add_value(v, " " + ResourceManager.getInstance().getString("message","ranch_cash_message"));
        }
        
        public function text(s:String, plus:Boolean=true):void{
            if (plus){
                plus_text = s;
            } else {
                minus_text = s;
            }
        }
        
        public function set_target(t:MapObject):void{
            var clickPoint:Point = new Point((t.x + (t._width / 2)), t.y);
            target = t.parent.localToGlobal(clickPoint);
        }
        
        public function add_value(v:Number, s:String):void{
            if (!v){
                return;
            }
            if (v > 0){
                plus_text = (plus_text + ((("+" + Algo.number_format(v)) + s) + "   "));
            } else {
                minus_text = (minus_text + ((Algo.number_format(v) + s) + "   "));
            }
        }
        
        public function set_coords(x:Number, y:Number):void{
            target = new Point(x, y);
        }

    }
}
