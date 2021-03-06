﻿package classes.view.components.map {
    import flash.display.*;
    import flash.filters.*;
    import flash.text.*;

    public class Tooltip extends Sprite {

        private var container:Sprite;
        private var min_w:Number = 50;
        private var bg_color:Number = 0xCCCCCC;
        private var tf:TextField;
        private var min_h:Number = 50;

        public function Tooltip(){
            super();
            init();
        }
        
        public function setTextColor(value:Number):void{
            tf.textColor = value;
        }
        
        public function set_bg(value:Number):void{
            bg_color = value;
        }
        
        private function draw():void{
        }
        
        public function setText(t:String):void{
            tf.text = t;
        }
        
        private function init():void{
            container = new Sprite();
            tf = new TextField();
            addChild(container);
            container.addChild(tf);
            tf.multiline = true;
            tf.autoSize = TextFieldAutoSize.LEFT;
            var font:Font = new Verdana();
            var format:TextFormat = new TextFormat();
            format.align = TextFormatAlign.CENTER;
            format.font = font.fontName;
            format.size = 14;
            format.bold = true;
            format.color = 0xFFFFFF;
            tf.defaultTextFormat = format;
            tf.embedFonts = true;
            mouseEnabled = false;
            mouseChildren = false;
            tf.filters = [new GlowFilter(0, 1, 2, 2, 10)];
        }

    }
}
