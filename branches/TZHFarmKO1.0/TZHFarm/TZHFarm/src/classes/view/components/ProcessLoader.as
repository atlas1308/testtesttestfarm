package classes.view.components {
    import flash.events.*;
    import classes.utils.*;
    import flash.geom.*;
    import flash.display.*;
    import flash.text.*;

    public class ProcessLoader extends Sprite {

        public const COMPLETE:String = "complete";

        private var container:Sprite;
        private var delay:Number;
        private var interval:Number;
        private var min_w:Number = 50;
        public var pid:String;
        private var percent:Number = 0;
        private var tf:TextField;
        private var fill_color:Number = 0xAB00;
        private var bg_color:Number = 354048;
        private var padd:Number = 1;
        public var auto_mode:Boolean = false;
        private var action:String;
        private var start_time:Number;
        private var min_h:Number = 50;

        public function ProcessLoader(){
            super();
            init();
        }
        private function draw(e:Event):void{
            percent = Math.min(int((((Algo.time() - start_time) * 100) / delay)), 100);
            tf.text = (((action + ": ") + percent) + "%");
            var _w:Number = (tf.width + (2 * padd));
            var _h:Number = (tf.height + (2 * padd));
            container.graphics.clear();
            container.graphics.beginFill(bg_color, 1);
            container.graphics.lineStyle(1, 0, 0, true);
            container.graphics.drawRoundRect(0, 0, _w, _h, 10);
            container.graphics.endFill();
            container.graphics.beginFill(fill_color, 1);
            container.graphics.lineStyle(1, 0, 0, true);
            container.graphics.drawRoundRect(0, 0, ((_w * percent) / 100), _h, 10);
            container.graphics.endFill();
            container.graphics.lineStyle(1, 0x103600, 1, true);
            container.graphics.drawRoundRect(0, 0, _w, _h, 10);
            if (percent == 100){
                removeEventListener(Event.ENTER_FRAME, draw);
                dispatchEvent(new Event(COMPLETE));
            };
            container.x = (-(container.width) / 2);
            container.y = -(container.height);
        }
        public function stop():void{
            removeEventListener(Event.ENTER_FRAME, draw);
            visible = false;
        }
        public function start(data:Object, auto_coords:Boolean=true):void{
            var p:Point;
            this.action = data.action;
            auto_mode = (data.auto_mode) ? true : false;
            if (auto_mode){
                pid = data.pid;
            };
            start_time = Algo.time();
            if (data.delay_offset){
                start_time = (start_time - data.delay_offset);
            };
            this.delay = data.delay;
            if (auto_coords){
                p = parent.globalToLocal(new Point(data.x, data.y));
                x = p.x;
                y = p.y;
            };
            addEventListener(Event.ENTER_FRAME, draw);
        }
        private function init():void{
            container = new Sprite();
            tf = new TextField();
            addChild(container);
            container.addChild(tf);
            var comic:Font = new ComicSansBold();
            tf.autoSize = TextFieldAutoSize.LEFT;
            var format:TextFormat = new TextFormat();
            format.align = TextFormatAlign.CENTER;
            format.font = comic.fontName;
            format.size = 12;
            format.color = 0xFFFFFF;
            tf.defaultTextFormat = format;
            tf.embedFonts = true;
            tf.x = padd;
            tf.y = padd;
            mouseEnabled = false;
            mouseChildren = false;
        }
        public function remove():void{
            removeEventListener(Event.ENTER_FRAME, draw);
            parent.removeChild(this);
        }

    }
}
