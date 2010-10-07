package classes.utils {
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;
	
	/**
	 * 振荡器
	 */ 
    public class Oscillator extends EventDispatcher {

        private var timer:Timer;
        private var tweens:Array;
        private var list:Array;

        public function Oscillator(){
            super();
            init();
        }
        
        public function add(obj:DisplayObject, radius:Number):void{
            list.push({
                obj:obj,
                radius:radius
            });
        }
        
        public function stop():void{
            timer.stop();
        }
        
        private function onTimer(e:TimerEvent):void{
            var data:Object;
            var i:Number = 0;
            while (i < list.length) {
                data = list[i];
                if (!tweens[i]){
                    tweens[i] = new Object();
                    tweens[i].angle = ((Math.random() * Math.PI) * 2);
                    tweens[i].radius_x = (10 + (Math.random() * data.radius));
                    tweens[i].radius_y = (10 + (Math.random() * data.radius));
                    tweens[i].current_angle = 0;
                    tweens[i].current_radius_y = 0;
                    tweens[i].current_radius_x = 0;
                    tweens[i].center_x = data.obj.x;
                    tweens[i].center_y = data.obj.y;
                    tweens[i].max_radius = data.radius;
                    tweens[i].delta_angle = (Math.PI / (10 + (Math.random() * 10)));
                    tweens[i].obj = data.obj;
                };
                update_position(i);
                i++;
            };
        }
        
        public function start():void{
            timer.start();
        }
        
        public function reset():void{
            timer.reset();
            list = new Array();
            var i:Number = 0;
            while (i < tweens.length) {
                tweens[i].obj.x = tweens[i].center_x;
                tweens[i].obj.y = tweens[i].center_y;
                i++;
            };
            tweens = new Array();
        }
        
        private function init():void{
            list = new Array();
            tweens = new Array();
            timer = new Timer((1000 / 24));
            timer.addEventListener(TimerEvent.TIMER, onTimer);
            timer.start();
        }
        
        private function update_position(index:Number):void{
            var data:Object = tweens[index];
            var obj:DisplayObject = (data.obj as DisplayObject);
            data.current_angle = (data.current_angle + data.delta_angle);
            data.current_radius_y = (data.current_radius_y + ((data.radius_y - data.current_radius_y) / 10));
            data.current_radius_x = (data.current_radius_x + ((data.radius_x - data.current_radius_x) / 10));
            obj.x = (data.center_x + (Math.cos(data.current_angle) * data.current_radius_x));
            obj.y = (data.center_y + (Math.sin(data.current_angle) * data.current_radius_y));
            if (Math.abs((data.current_radius_x - data.radius_x)) < 0.1){
                data.angle = ((Math.random() * Math.PI) * 2);
                data.radius_x = (Math.random() * data.max_radius);
                data.radius_y = (Math.random() * data.max_radius);
                data.delta_angle = (Math.PI / (10 + (Math.random() * 10)));
            };
        }

    }
}
