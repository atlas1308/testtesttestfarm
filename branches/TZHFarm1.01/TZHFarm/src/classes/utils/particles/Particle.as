package classes.utils.particles {
    import flash.events.*;
    import classes.utils.*;
    import flash.geom.*;
    import flash.display.*;
    import flash.utils.*;

    public class Particle extends Sprite {

        protected var speed_x:Number;
        protected var speed_y:Number;
        public var span_x:Number = 0;
        protected var scale:Number;
        protected var particle:MovieClip;
        protected var speed:Number;
        protected var time_started:Number;
        protected var angle:Number;
        public var particle_skin:Number = 2;
        protected var source_x:Number = 0;
        protected var time_scale:Number = 5;
        public var color:Number = 0xFF0000;
        public var source_y:Number = 0;
        protected var gravity:Number;
        public var min_source_distance:Number;
        protected var min_angle_delta:Number = 1.0471975511966;
        protected var max_scale:Number = 1;
        protected var life_time:Number;
        protected var y_limit:Number;
        protected var max_angle_delta:Number = 1.5707963267949;
        public var max_source_distance:Number;
        protected var min_scale:Number = 0.8;

        public function Particle(){
            super();
        }
        protected function stop():void{
            removeEventListener(Event.ENTER_FRAME, loop);
            if (parent){
                parent.removeChild(this);
            };
        }
        protected function init():void{
            particle = new particle_template();
            addChild(particle);
            var cR:Number = ((color >> 16) / 100);
            var cG:Number = (((color >> 8) & 0xFF) / 100);
            var cB:Number = ((color & 0xFF) / 100);
            var trans:Transform = new Transform(particle);
            cacheAsBitmap = true;
            angle = (((Math.PI / 12) + (Math.PI / 2)) - ((Math.random() * Math.PI) / 6));
            gravity = 9.8;
            speed = ((Math.random() * 20) + 10);
            speed_x = (speed * Math.cos(angle));
            speed_y = (speed * Math.sin(angle));
            y_limit = (source_y + Algo.rand(min_source_distance, max_source_distance));
            life_time = ((Math.random() * 3000) + 2000);
            scale = Algo.rand(min_scale, max_scale, false);
            particle.scaleX = (particle.scaleY = scale);
            particle.gotoAndStop(particle_skin);
        }
        
        public function start():void{
            init();
            addEventListener(Event.ENTER_FRAME, loop);
            time_started = getTimer();
        }
        
        protected function loop(e:Event):void{
            var t:Number = ((time_scale * (getTimer() - time_started)) / 1000);
            particle.y = (source_y - ((speed_y * t) - ((((1 / 2) * gravity) * t) * t)));
            if (particle.y > y_limit){
                particle.y = y_limit;
                particle.alpha = (particle.alpha - 0.1);
            } else {
                particle.x = (speed_x * t);
            }
            if ((getTimer() - time_started) > life_time){
                stop();
            }
        }
    }
}
