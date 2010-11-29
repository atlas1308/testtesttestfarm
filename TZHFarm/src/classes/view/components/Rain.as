package classes.view.components {
    import fl.motion.easing.*;
    import fl.transitions.*;
    
    import flash.display.*;
    import flash.utils.*;

    public class Rain extends MovieClip {

        private var anim:rain_animation;
        private var interval:Number;
        private var rain_stops:Tween;

        public function Rain(){
            super();
            mouseEnabled = false;
            mouseChildren = false;
        }
        
        private function removeRain():void{
            if (anim){
            	anim.stop();
                removeChild(anim);
                if (rain_stops){
                    rain_stops.stop();
                }
                clearTimeout(interval);
            }
            anim = null;
        }
        
        public function start():void{
            this.removeRain();
            anim = new rain_animation();
            addChild(anim);
            var scale:Number = ((stage.stageWidth * 1.5) / anim.width);
            anim.scaleX = (anim.scaleY = scale);
            interval = setTimeout(stopRain, 5000);// 5000
        }
        
        private function stopRain():void{
        	/* if(rain_stops && rain_stops.hasEventListener(TweenEvent.MOTION_FINISH)){
        		this.removeRain();
        		rain_stops.removeEventListener(TweenEvent.MOTION_FINISH, removeRain);
        	} */
            /* rain_stops = new Tween(this, "alpha", Exponential.easeInOut, 1, 0, 0.5, true);
            rain_stops.addEventListener(TweenEvent.MOTION_FINISH, removeRain); */
            this.removeRain();
        }

    }
}
