package classes.utils.particles {
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;

    public class Bubble extends MovieClip {

        private var focusEffect:Boolean = true;
        private var maxoscspeed = 30;
        private var ineractive:Boolean = false;
        private var finalY = 0;
        private var minScale = 10;
        private var oscspeed = 30;
        private var xLimit = 200;
        private var blendType:String = "normal";
        private var minAlpha = 20;
        private var hFlow = 0;
        private var oscAmount = 1;
        private var storedBlur:Array;
        private var speed = 1;
        private var scale = 100;
        private var generator:DisplayObjectContainer;
        private var blurValue = 0;
        private var angle = 0;
        private var bottomFadeMargin = 30;
        private var maxScale = 90;
        private var maxAlpha = 100;
        private var blurred:BlurFilter;
        private var maxspeed = 5;
        private var currentAlpha = 50;
        private var movementMode = 1;
        private var skin:MovieClip;
        private var topFadeMargin = 50;

        public function Bubble(gen:DisplayObjectContainer, skin:MovieClip, mov:int, i:Boolean, bT:String, fY:Number, xL:Number, ms:Number, hF:Number, os:Number, oa:Number, mins:Number, maxs:Number, mina:Number, maxa:Number, topm:Number, bottomm:Number, fe:Boolean){
            super();
            addChild(skin);
            generator = gen;
            movementMode = mov;
            ineractive = i;
            blendType = bT;
            finalY = (fY + (Math.random() * 15));
            xLimit = xL;
            maxspeed = ms;
            hFlow = hF;
            maxoscspeed = os;
            oscAmount = oa;
            minScale = mins;
            maxScale = maxs;
            minAlpha = mina;
            maxAlpha = maxa;
            topFadeMargin = topm;
            bottomFadeMargin = bottomm;
            focusEffect = fe;
            StartBubble();
            generator.addChild(this);
            this.addEventListener(Event.ENTER_FRAME, updateBubble);
            if (ineractive){
                this.addEventListener(MouseEvent.CLICK, bubbleClicked);
            };
        }
        private function checkPop(e:Event):void{
            if (this.currentLabel == "popped"){
                this.removeEventListener(Event.ENTER_FRAME, checkPop);
                this.gotoAndPlay("loop");
                if (ineractive){
                    this.addEventListener(MouseEvent.CLICK, bubbleClicked);
                };
                StartBubble();
            }
        }
        private function updateBubble(e:Event):void{
            this.y = (this.y - (Math.cos(angle) * speed));
            this.x = (this.x + (Math.sin(angle) * speed));
            this.x = (this.x + hFlow);
            this.x = (this.x + (Math.sin((this.y / oscspeed)) * oscAmount));
            if ((((this.y < (-(finalY) + topFadeMargin))) && (!((topFadeMargin == 0))))){
                this.alpha = (((this.y + finalY) * currentAlpha) / topFadeMargin);
            };
            if ((((((this.y < 0)) && ((this.y > -(bottomFadeMargin))))) && (!((bottomFadeMargin == 0))))){
                this.alpha = ((this.y * currentAlpha) / -(bottomFadeMargin));
            };
            if (bottomFadeMargin == 0){
                this.alpha = currentAlpha;
            };
            if (this.y < -(finalY)){
                StartBubble();
            };
        }
        public function changeBubbleParameters(mov:int, i:Boolean, bT:String, fY:Number, xL:Number, ms:Number, hF:Number, os:Number, oa:Number, mins:Number, maxs:Number, mina:Number, maxa:Number, topm:Number, bottomm:Number, fe:Boolean):void{
            movementMode = mov;
            ineractive = i;
            blendType = bT;
            maxspeed = ms;
            hFlow = hF;
            maxoscspeed = os;
            oscAmount = oa;
            minScale = mins;
            maxScale = maxs;
            minAlpha = mina;
            maxAlpha = maxa;
            topFadeMargin = topm;
            bottomFadeMargin = bottomm;
            focusEffect = fe;
            finalY = (fY + (Math.random() * 40));
            xLimit = xL;
            if (finalY <= 0){
                finalY = (generator.stage.stageHeight - topFadeMargin);
            };
            if (xLimit <= 0){
                xLimit = generator.stage.stageWidth;
            };
            if (ineractive){
                this.addEventListener(MouseEvent.CLICK, bubbleClicked);
            };
        }
        private function StartBubble():void{
            if (finalY <= 0){
                finalY = (generator.stage.stageHeight - topFadeMargin);
            };
            if (xLimit <= 0){
                xLimit = generator.stage.stageWidth;
            };
            this.y = 0;
            switch (movementMode){
                case -1:
                    this.x = 0;
                    angle = 0;
                    break;
                case 0:
                    this.x = (Math.round((Math.random() * xLimit)) - (xLimit * 0.5));
                    angle = 0;
                    break;
                case 1:
                    this.x = 0;
                    angle = ((Math.random() * 1) - 0.5);
                    break;
            };
            scale = (Math.random() * maxScale);
            if (scale < minScale){
                scale = minScale;
            };
            this.scaleX = scale;
            this.scaleY = scale;
            speed = ((maxspeed / scale) * 0.5);
            oscspeed = (Math.round((Math.random() * maxoscspeed)) + 20);
            if (focusEffect){
                if (scale > 1.1){
                    blurValue = (scale * 5);
                };
                if (scale < 0.8){
                    blurValue = ((1 / scale) * 0.5);
                };
                if (blurValue > 0){
                    blurred = new BlurFilter(blurValue, blurValue, 2);
                    storedBlur = [blurred];
                    this.filters = storedBlur;
                };
            };
            currentAlpha = (Math.random() * maxAlpha);
            if (currentAlpha < minAlpha){
                currentAlpha = minAlpha;
            };
            this.alpha = 0;
            this.blendMode = blendType;
        }
        private function bubbleClicked(e:MouseEvent):void{
            this.gotoAndPlay("pop");
            this.removeEventListener(MouseEvent.CLICK, bubbleClicked);
            this.addEventListener(Event.ENTER_FRAME, checkPop);
        }

    }
}
