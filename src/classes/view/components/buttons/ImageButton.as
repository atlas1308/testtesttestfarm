package classes.view.components.buttons
{
    import classes.utils.*;
    
    import flash.display.*;
    import flash.events.*;

    public class ImageButton extends Sprite
    {
        protected var container:Sprite;
        protected var bmp:Bitmap;
        protected var cache:Cache;
        protected var alpha_over:Number = 1;
        protected var line_color_over:Number = 16777215;
        protected var _disabled:Boolean = false;
        protected var alpha_down:Number = 1;
        protected var line_color_out:Number = 16777215;
        protected var h:Number;
        protected var line_color_down:Number = 10892292;
        protected var bg_color_over:Number = 16513510;
        protected var bmp_cont:Sprite;
        protected var alpha_out:Number = 0.5;
        protected var url:String;
        protected var bg_cont:Sprite;
        protected var bg_color_out:Number = 16513510;
        protected var w:Number;
        protected var bg_color_down:Number = 16513510;

        public function ImageButton(w:Number, h:Number, url:String)
        {
            this.w = w;
            this.h = h;
            this.url = url;
            this.init();
        }

        public function disable() : void
        {
            _disabled = true;
            buttonMode = false;
            useHandCursor = false;
            draw(13421772, 15132390, 0.5);
        }

        public function selected() : void
        {
            line_color_out = line_color_down;
            line_color_over = line_color_down;
            mouseOut(null);
        }

        protected function mouseOut(event:MouseEvent) : void
        {
            if (_disabled)
            {
                return;
            }
            draw(bg_color_out, line_color_out, alpha_out);
        }

        public function use_as_image() : void
        {
            removeEventListener(MouseEvent.MOUSE_OVER, mouseOver);
            removeEventListener(MouseEvent.MOUSE_OUT, mouseOut);
            removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
            removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
            draw(0, 0, 0, 0);
            buttonMode = false;
            useHandCursor = false;
        }

        protected function mouseUp(event:MouseEvent) : void
        {
            if (_disabled)
            {
                return;
            }
            mouseOver(event);
        }

        protected function draw(color:uint, alpha:Number, a:*, b:Number = 1) : void
        {
            bg_cont.graphics.clear();
            bg_cont.graphics.beginFill(color, alpha);
            bg_cont.graphics.lineStyle(1, color, alpha, true, "normal", "round", "round");
            bg_cont.graphics.drawRoundRect(0, 0, w, h, 6);
            bg_cont.graphics.endFill();
        }

        protected function onLoadComplete(event:Event) : void
        {
            bmp = event.target.asset as Bitmap;
            bmp_cont.addChild(bmp);
            bmp.x = (w - bmp.width) / 2;
            bmp.y = (h - bmp.height) / 2;
        }

        protected function init() : void
        {
            container = new Sprite();
            addChild(container);
            bg_cont = new Sprite();
            container.addChild(bg_cont);
            bmp_cont = new Sprite();
            container.addChild(bmp_cont);
            cache = new Cache();
            cache.addEventListener(Cache.LOAD_COMPLETE, onLoadComplete);
            cache.load(url);
            container.mouseEnabled = false;
            container.mouseChildren = false;
            buttonMode = true;
            useHandCursor = true;
            addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
            addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
            addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
            addEventListener(MouseEvent.MOUSE_UP, mouseUp);
            mouseOut(null);
        }

        protected function mouseOver(event:MouseEvent) : void
        {
            if (_disabled)
            {
                return;
            }
            draw(bg_color_over, line_color_over, alpha_over);
        }

        protected function mouseDown(event:MouseEvent) : void
        {
            if (_disabled)
            {
                return;
            }
            draw(bg_color_down, line_color_down, alpha_down);
        }

        public function is_disabled() : Boolean
        {
            return _disabled;
        }

    }
}
