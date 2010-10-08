package classes.view.components {
    import flash.display.*;
    import flash.utils.*;
    import fl.transitions.*;
    import fl.motion.easing.*;

    public class Rain extends MovieClip {

        private var anim:rain_animation;
        private var interval:Number;
        private var rain_stops:Tween;

        public function Rain(){
            super();
            mouseEnabled = false;
            mouseChildren = false;
        }
        private function removeRain(e:TweenEvent):void{
            removeChild(anim);
            anim = null;
        }
        public function start():void{
            if (anim){
                removeChild(anim);
                if (rain_stops){
                    rain_stops.stop();
                };
                clearTimeout(interval);
            };
            anim = new rain_animation();
            addChild(anim);
            var r:Number = ((stage.stageWidth * 1.5) / anim.width);
            anim.scaleX = (anim.scaleY = r);
            interval = setTimeout(stopRain, 5000);
        }
        private function stopRain():void{
            rain_stops = new Tween(this, "alpha", Exponential.easeInOut, 1, 0, 5.5, true);
            rain_stops.addEventListener(TweenEvent.MOTION_FINISH, removeRain);
        }

    }
}
