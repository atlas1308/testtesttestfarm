﻿package classes.view.components.shop {
    import flash.events.*;
    import flash.display.*;
    import flash.text.*;
	
	import flash.ui.Mouse;


    public class ShopTab extends Sprite {

        public const CLICKED:String = "clicked";

        private var container:Sprite;
        private var is_new:Boolean = false;
        private var new_tag:NewTag;
        public var title:String;
        private var padd_h:Number = 3;
	
        private var selected:Boolean = false;
        private var default_line_color:Number = 15700748;
        private var select_color:Number = 15912798;
        private var default_color:Number = 16513510;
        private var padd_w:Number = 10;
        private var _name:TextField;
        private var select_line_color:Number = 16489231;

        public function ShopTab(title:String, is_new:Boolean=false){
            super();
            this.title = title;
            this.is_new = is_new;
            init();
        }
        private function prep_title(t:String):String{
            return ((String(t.charAt(0)).toUpperCase() + t.slice(1, t.length)));
        }
        private function init():void{
			this.buttonMode=true;
			this.useHandCursor=true; 
			this.mouseChildren=false; 
			container = new Sprite();
            addChild(container);
            _name = new TextField();
            //
             _name.autoSize = TextFieldAutoSize.CENTER;
            _name.selectable = false;
            var hobo:Font = new HoboStd();
            var tf:TextFormat = new TextFormat();
            tf.font = hobo.fontName;
            tf.color = 10049312;
            tf.size = 18;
            _name.defaultTextFormat = tf;
            _name.embedFonts = true;
            _name.text = prep_title(title);
            container.addChild(_name);
            drawBg(default_color, default_line_color);
            new_tag = new NewTag();
            if (is_new){
                addChild(new_tag);
            };
            align_tag();
            addEventListener(MouseEvent.MOUSE_UP, mouseUp);
            addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
            addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
        }
        public function unselect(){
            selected = false;
            drawBg(default_color, default_line_color);
        }
        private function mouseOver(e:MouseEvent):void{
            drawBg(select_color, select_line_color);
            var dx:Number = ((container.width * 0.2) / 2);
            var dy:Number = ((container.height * 0.2) / 2);
            container.scaleX = (container.scaleY = 1.2);
            container.x = -(dx);
            container.y = -(dy);
            align_tag(true);
        }
        private function mouseOut(e:MouseEvent):void{
            container.scaleX = (container.scaleY = 1);
            container.x = (container.y = 0);
            if (selected){
                drawBg(select_color, select_line_color);
            } else {
                drawBg(default_color, default_line_color);
            };
            align_tag();
        }
        private function mouseUp(e:MouseEvent):void{
            dispatchEvent(new Event(CLICKED));
        }
        private function align_tag(scale:Boolean=false):void{
            new_tag.gotoAndStop((scale) ? 2 : 1);
            new_tag.x = (container.x - (new_tag.width / 4));
            new_tag.y = (container.y - (new_tag.height / 2));
        }
        private function drawBg(bg, outline):void{
            var _w:Number = (_name.width + (2 * padd_w));
            var _h:Number = (_name.height + (2 * padd_h));
            container.graphics.clear();
            container.graphics.lineStyle(2, outline, 1, false);
            container.graphics.beginFill(bg, 1);
            container.graphics.drawRoundRect(0, 0, _w, _h, 10);
            container.graphics.endFill();
            _name.x = padd_w;
            _name.y = padd_h;
        }
        public function select(){
            selected = true;
            drawBg(select_color, select_line_color);
        }

    }
}