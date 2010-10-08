package classes.view.components {
    import flash.events.*;
    import flash.geom.*;
    import flash.display.*;
    import flash.utils.*;
    import flash.net.*;
    import flash.filters.*;
    import flash.text.*;
    import fl.transitions.*;
    import fl.transitions.easing.*;
    import flash.media.*;
    import flash.ui.*;
    import flash.system.*;
    import flash.errors.*;
    import flash.external.*;
    import adobe.utils.*;
    import flash.accessibility.*;
    import flash.printing.*;
    import flash.profiler.*;
    import flash.sampler.*;
    import flash.xml.*;
	
	/**
	 * 这个类暂时还没有使用到
	 */ 
    public dynamic class GiftBox extends MovieClip {

        public var main_image_mc:imageMC;
        public var button_brightness_intensity:Number;
        public var maskMC:Sprite;
        public var interval:Number;
        public var glow_color_name:String;
        public var shineTarget:MovieClip;
        public var has_events:Boolean;
        public var shine_intensity:uint;
        public var glow_blur_width:uint;
        public var add_glow_effect:Boolean;
        public var clicked:Boolean;
        public var shine_move_speed:uint;
        public var loop:Boolean;
        public var shine_width:uint;

        public function GiftBox(){
            addFrameScript(0, frame1);
        }
        public function shine():void{
            imageShiner(shine_move_speed, shine_intensity, shine_width, add_glow_effect, glow_color_name, glow_blur_width, loop);
        }
        function frame1(){
            trace("script start");
            shineTarget = new imageMC();
            this.addChild(shineTarget);
            maskMC = new Sprite();
            this.addChild(maskMC);
            maskMC.cacheAsBitmap = true;
            shineTarget.cacheAsBitmap = true;
            shineTarget.mask = maskMC;
            shine_move_speed = 7;
            shine_intensity = 20;
            shine_width = 50;
            add_glow_effect = false;
            glow_color_name = "gold";
            glow_blur_width = 2;
            loop = false;
            button_brightness_intensity = 100;
            has_events = true;
            this.buttonMode = true;
            this.addEventListener(MouseEvent.CLICK, onButtonClick);
            this.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
            this.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
            this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            trace("has events", has_events);
            stop();
            clicked = false;
            interval = setInterval(shine, 2000);
        }
        public function onButtonClick(event:MouseEvent):void{
            if (!has_events){
                return;
            };
            clearInterval(interval);
            clicked = true;
        }
        public function imageShiner(shine_move_speed:uint, shine_intensity:uint, shine_width:uint, add_glow_effect:Boolean, glow_color_name:String, glow_blur_width:uint, loop:Boolean):void{
            var shine_move_speed:* = shine_move_speed;
            var shine_intensity:* = shine_intensity;
            var shine_width:* = shine_width;
            var add_glow_effect:* = add_glow_effect;
            var glow_color_name:* = glow_color_name;
            var glow_blur_width:* = glow_blur_width;
            var loop:* = loop;
            var imageShine:* = function (mc:MovieClip, shine_intensity:uint){
                var colorTrans:ColorTransform = new ColorTransform();
                var color:uint = shine_intensity;
                colorTrans.redOffset = color;
                colorTrans.redMultiplier = ((color / 100) + 1);
                colorTrans.greenOffset = color;
                colorTrans.greenMultiplier = ((color / 100) + 1);
                colorTrans.blueOffset = color;
                colorTrans.blueMultiplier = ((color / 100) + 1);
                mc.transform.colorTransform = colorTrans;
            };
            var imageGlower:* = function (mc:MovieClip, glow_intensity:uint, glow_blur:uint, glow_quality:uint, glow_color_name:String):void{
                var glow_colors:Array;
                var glow_distance:uint;
                var glow_angleInDegrees:uint = 45;
                if (glow_color_name == "gold"){
                    glow_colors = [0x660000, 0xFF6600, 0xFFAA00, 16777164];
                };
                if (glow_color_name == "blue"){
                    glow_colors = [13209, 13209, 39423, 10079487];
                };
                if (glow_color_name == "green"){
                    glow_colors = [0x6600, 0x339900, 0x99FF00, 16777164];
                };
                if (glow_color_name == "ocean"){
                    glow_colors = [0x3333, 3368550, 10079436, 13434879];
                };
                if (glow_color_name == "aqua"){
                    glow_colors = [0x3333, 0x6666, 0xCCCC, 0xFFFF];
                };
                if (glow_color_name == "ice"){
                    glow_colors = [13158, 3368601, 6724044, 10079487];
                };
                if (glow_color_name == "spark"){
                    glow_colors = [102, 26265, 3394815, 13434879];
                };
                if (glow_color_name == "silver"){
                    glow_colors = [0x333333, 0x666666, 0xBBBBBB, 0xFFFFFF];
                };
                if (glow_color_name == "neon"){
                    glow_colors = [3355596, 6697932, 10066431, 13421823];
                };
                var glow_alphas:Array = [0, 1, 1, 1];
                var glow_ratios:Array = [0, 63, 126, 0xFF];
                var glow_blurX:uint = glow_blur;
                var glow_blurY:uint = glow_blur;
                var glow_strength:uint = glow_intensity;
                var glow_type:String = "outer";
                var glow_knockout:Boolean;
                var filter:GradientGlowFilter = new GradientGlowFilter(glow_distance, glow_angleInDegrees, glow_colors, glow_alphas, glow_ratios, glow_blurX, glow_blurY, glow_strength, glow_quality, glow_type, glow_knockout);
                var filterArray:Array = new Array();
                filterArray.push(filter);
                mc.filters = filterArray;
            };
            var linearFader:* = function (target:MovieClip, shine_width:uint, shine_move_speed:uint, mask_space:uint):void{
                var mask_width:* = 0;
                var mask_height:* = 0;
                var degree:* = 0;
                var fillType:* = null;
                var colors:* = null;
                var alphas:* = null;
                var ratios:* = null;
                var spreadMethod:* = null;
                var matr:* = null;
                var start_position:* = 0;
                var current_position:* = 0;
                var end_position:* = 0;
                var moveFade:* = null;
                var target:* = target;
                var shine_width:* = shine_width;
                var shine_move_speed:* = shine_move_speed;
                var mask_space:* = mask_space;
                moveFade = function (e:Event):void{
                    matr.createGradientBox(shine_width, mask_height, ((Math.PI / 180) * degree), current_position, 0);
                    maskMC.graphics.clear();
                    maskMC.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
                    maskMC.graphics.drawRect(0, 0, mask_width, mask_height);
                    maskMC.graphics.endFill();
                    if (end_position > current_position){
                        current_position = (current_position + shine_move_speed);
                    } else {
                        if (loop){
                            current_position = start_position;
                        } else {
                            target.removeEventListener(Event.ENTER_FRAME, moveFade);
                        };
                    };
                };
                mask_width = (target.width + mask_space);
                mask_height = (target.height + mask_space);
                maskMC.x = -((mask_space / 2));
                maskMC.y = -((mask_space / 2));
                degree = 45;
                fillType = GradientType.LINEAR;
                colors = [0, 0, 0];
                alphas = [0, 1, 0];
                ratios = [0, 127, 0xFF];
                spreadMethod = SpreadMethod.PAD;
                matr = new Matrix();
                start_position = -((shine_width + mask_space));
                current_position = start_position;
                end_position = ((target.width + shine_width) + mask_space);
                target.addEventListener(Event.ENTER_FRAME, moveFade);
            };
            imageShine(shineTarget, shine_intensity);
            imageGlower(shineTarget.handler, 1, glow_blur_width, 15, glow_color_name);
            linearFader(shineTarget, shine_width, shine_move_speed, 10);
        }
        public function onMouseOut(event:MouseEvent):void{
            if (!has_events){
                return;
            };
            clearInterval(interval);
            if (!clicked){
                interval = setInterval(shine, 2000);
            };
        }
        public function disable_button():void{
            trace("disable button");
            this.buttonMode = false;
            has_events = false;
            trace("has events", has_events);
        }
        public function onMouseDown(event:MouseEvent):void{
            if (!has_events){
                return;
            };
            imageShineFade(this, button_brightness_intensity, 0, 1);
        }
        public function imageShineFade(mc:MovieClip, startShinePercent:uint, endShinePercent:uint, shineSpeed:uint):void{
            var colorTrans:* = null;
            var colorSliderOver:* = false;
            var fadeOverCheck:* = null;
            var mc:* = mc;
            var startShinePercent:* = startShinePercent;
            var endShinePercent:* = endShinePercent;
            var shineSpeed:* = shineSpeed;
            fadeOverCheck = function (e:Event):void{
                if (colorSliderOver == false){
                    mc.transform.colorTransform = colorTrans;
                } else {
                    mc.removeEventListener(Event.ENTER_FRAME, fadeOverCheck);
                };
            };
            var colorSlider:* = function (who:ColorTransform, startvalue:int, endvalue:int, speed:uint, prop:String, ease){
                var colorSlider:* = null;
                var stopColorSlider:* = null;
                var who:* = who;
                var startvalue:* = startvalue;
                var endvalue:* = endvalue;
                var speed:* = speed;
                var prop:* = prop;
                var ease:* = ease;
                stopColorSlider = function (tevt:TweenEvent):void{
                    colorSlider.removeEventListener(TweenEvent.MOTION_FINISH, stopColorSlider);
                    colorSliderOver = true;
                };
                colorSlider = new Tween(who, prop, ease, startvalue, endvalue, speed, true);
                colorSlider.addEventListener(TweenEvent.MOTION_FINISH, stopColorSlider);
            };
            colorTrans = new ColorTransform();
            var color:* = 0;
            colorTrans.redOffset = color;
            colorTrans.greenOffset = color;
            colorTrans.blueOffset = color;
            colorSliderOver = false;
            colorSlider(colorTrans, startShinePercent, endShinePercent, shineSpeed, "redOffset", Strong.easeOut);
            colorSlider(colorTrans, ((startShinePercent / 100) + 1), (1 + (endShinePercent / 100)), shineSpeed, "redMultiplier", Strong.easeOut);
            colorSlider(colorTrans, startShinePercent, endShinePercent, shineSpeed, "greenOffset", Strong.easeOut);
            colorSlider(colorTrans, ((startShinePercent / 100) + 1), (1 + (endShinePercent / 100)), shineSpeed, "greenMultiplier", Strong.easeOut);
            colorSlider(colorTrans, startShinePercent, endShinePercent, shineSpeed, "blueOffset", Strong.easeOut);
            colorSlider(colorTrans, ((startShinePercent / 100) + 1), (1 + (endShinePercent / 100)), shineSpeed, "blueMultiplier", Strong.easeOut);
            mc.addEventListener(Event.ENTER_FRAME, fadeOverCheck);
        }
        public function onMouseOver(event:MouseEvent):void{
            trace("over has events", has_events);
            if (!has_events){
                return;
            };
            clearInterval(interval);
            shine();
        }

    }
}
