package classes.utils.particles {
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;

    public class Bubbles extends Sprite {

        protected var ALPHA_MIN:Number = 1;
        protected var INTERACTIVE:Boolean = true;
        protected var ALPHA_MAX:Number = 1;
        protected var FOCUS_EFFECT:Boolean = false;
        protected var INTERVAL_CREATION_SEC:Number = 0.1;
        protected var MAX_BUBBLES:Number = 15;
        protected var OSCILLATION_AMOUNT:Number = 0;
        protected var MOVEMENT_MODE:Number = 0;
        protected var FADE_TOP_MARGIN:Number = 50;
        protected var timerCreation:Timer;
        protected var SCALE_MIN:Number = 0.7;
        protected var HORIZONTAL_FLOW:Number = 0.4;
        protected var SPEED_MAX:Number = 1;
        protected var MAX_DISTANCE_FROM_GENERATOR:Number = 60;
        protected var bubbles:Array;
        protected var SCALE_MAX:Number = 0.8;
        protected var BLEND_MODE:String = "normal";
        protected var SPREAD:Number = 60;
        protected var OSCILLATION_MAX_SPEED:Number = 0.5;
        protected var FADE_BOTTOM_MARGIN:Number = 50;

        public function Bubbles():void{
            bubbles = new Array();
            super();
            init();
        }
        protected function init():void{
            if (INTERVAL_CREATION_SEC == 0){
                timerCreation = new Timer(1000, MAX_BUBBLES);
            } else {
                timerCreation = new Timer((INTERVAL_CREATION_SEC * 1000), MAX_BUBBLES);
            };
            timerCreation.addEventListener(TimerEvent.TIMER, createBubble);
            timerCreation.start();
        }
        public function changeBubblesParameters():void{
            var b:* = 0;
            while (b < bubbles.length) {
                bubbles[b].changeBubbleParameters(MOVEMENT_MODE, INTERACTIVE, BLEND_MODE, MAX_DISTANCE_FROM_GENERATOR, SPREAD, SPEED_MAX, HORIZONTAL_FLOW, OSCILLATION_MAX_SPEED, OSCILLATION_AMOUNT, SCALE_MIN, SCALE_MAX, ALPHA_MIN, ALPHA_MAX, FADE_TOP_MARGIN, FADE_BOTTOM_MARGIN, FOCUS_EFFECT);
                b++;
            };
        }
        protected function createBubble(e:Event):void{
            var skin:MovieClip = new particle_template();
            skin.gotoAndStop(9);
            bubbles.push(new Bubble(this, skin, MOVEMENT_MODE, INTERACTIVE, BLEND_MODE, MAX_DISTANCE_FROM_GENERATOR, SPREAD, SPEED_MAX, HORIZONTAL_FLOW, OSCILLATION_MAX_SPEED, OSCILLATION_AMOUNT, SCALE_MIN, SCALE_MAX, ALPHA_MIN, ALPHA_MAX, FADE_TOP_MARGIN, FADE_BOTTOM_MARGIN, FOCUS_EFFECT));
        }

    }
}
