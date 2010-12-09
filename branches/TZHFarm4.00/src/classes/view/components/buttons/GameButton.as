package classes.view.components.buttons {
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class GameButton extends Sprite {

        protected var container:Sprite;
        protected var hover_scale:Number = 1.2;
        protected var fixed_width:Number = 0;
        protected var disabled_bg_color:Number = 0x666666;
        protected var disabled_txt_color:Number = 0xCCCCCC;
        protected var text_size:Number = 17;
        protected var text_color:Number = 0xFFFFFF;
        protected var padd_h:Number = 2;
        protected var _disabled:Boolean = false;
        protected var line_color:Number = 3567874;
        protected var bg_color:Number = 7382796;
        protected var bg_color_over:Number = 9426191;
        
        /* protected var line_color:Number = 3567874;
        protected var bg_color:Number = 0xDB9600;
        protected var bg_color_over:Number = 0xFD9F13; */
        protected var padd_w:Number = 5;
        protected var tf:TextField;
        protected var disabled_line_color:Number = 0x999999;
        
        
        public static const GREEN_STYLE_TYPE:String = "green";

        public function GameButton(label:String="", text_size:Number=17, hover_scale:Number = 1.12){
            super();
            this.text_size = text_size;
            this.hover_scale = hover_scale;
            init();
            set_label(label);
        }
        
        public function enable():void{
            _disabled = false;
            container.buttonMode = true;
            container.useHandCursor = true;
            refresh();
        }
        
        protected function draw(boderColor:Number, backgroundColor:uint, scale:Number=1):void{
            var _w:Number = (fixed_width) ? fixed_width : (tf.width + (2 * padd_w));
            var _h:Number = (tf.height + (2 * padd_h));
            var g:Graphics = container.graphics;
            g.clear();
            g.beginFill(backgroundColor, 1);
            g.drawRoundRect(0, 0, _w, _h, 12);
            g.endFill();
            tf.x = ((_w - tf.width) / 2);
            tf.y = (padd_h + 1);
            container.scaleX = scale;
            container.scaleY = scale;
            if (scale > 1){
                container.x = ((-(_w) * (scale - 1)) / 2);
                container.y = ((-(_h) * (scale - 1)) / 2);
            } else {
                container.x = 0;
                container.y = 0;
            }
        }
        
        public function refresh():void{
            if (_disabled){
                draw(disabled_line_color, disabled_bg_color);
            } else {
                draw(line_color, bg_color);
            }
        }
        
        protected function mouseOut(e:MouseEvent):void{
            if (_disabled){
                return;
            }
            draw(line_color, bg_color);
        }
        
        protected function init():void{
            container = new Sprite();
            addChild(container);
            tf = new TextField();
            var hobo:Font = new HoboStd();
            tf.embedFonts = true;
            tf.autoSize = TextFieldAutoSize.LEFT;
            tf.selectable = false;
            var format:TextFormat = new TextFormat();
            format.font = hobo.fontName;
            format.size = text_size;
            format.color = text_color;
            tf.defaultTextFormat = format;
            container.addChild(tf);
            container.mouseChildren = false;
            container.buttonMode = true;
            container.useHandCursor = true;
            container.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
            container.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
            container.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
        }
        
        public function set_text_color(value:Number):void{
            text_color = value;
            tf.textColor = value;
        }
        
        public function set_label(v:String):void{
            tf.text = v;
            refresh();
        }
        
        public function get label():String {
        	if(tf)
        	{
        		return tf.text;
        	}
        	return "";
        }
        
        public function set_fixed_width(v:Number):void{
            fixed_width = v;
            refresh();
        }
        
        protected function mouseOver(e:MouseEvent):void{
            if (_disabled){
                return;
            }
            draw(line_color, bg_color_over, hover_scale);
        }
        
        public function set_style(style:String="mauve"):void{
            switch (style){
                case "mauve":
                	//set_colors(0x0089FD, 0x3EB0FD, 4733522);
                    set_colors(8417433, 10257349, 4733522);
                    break;
                case "blue":
                	//set_colors(0xDB9600, 0xFD9F13, 2580145);
                    set_colors(3968452, 432363, 2580145);
                    break;
                case "green":
                	set_colors(7382796, 9426191, 3567874);
                	break;
            }
        }
        
        public function disable():void{
            _disabled = true;
            container.buttonMode = false;
            container.useHandCursor = false;
            refresh();
        }
        
        public function set_colors(bg:Number, bg_over:Number, line:Number):void{
            bg_color = bg;
            bg_color_over = bg_over;
            line_color = line;
            refresh();
        }
        
        protected function mouseDown(e:MouseEvent):void{
            if (_disabled){
                return;
            }
            draw(line_color, bg_color);
        }
        
        public function set_text_size(v:Number):void{
            text_size = v;
            var format:TextFormat = tf.getTextFormat();
            format.size = text_size;
            tf.setTextFormat(format);
            refresh();
        }
        
        public function is_disabled():Boolean{
            return (_disabled);
        }
        
        public function set_padd_height(padd_h:Number):void{
            this.padd_h = padd_h;
            refresh();
        }

    }
} 
