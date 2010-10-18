package classes.view.components {
    import flash.display.*;
    import flash.text.*;

    public class Tooltip extends Sprite {

        private var arr:arrow;
        private var container:Sprite;
        private var min_w:Number = 50;
        private var bg_color:Number = 4925711;
        private var padd:Number = 4;
        private var tf:TextField;
        private var min_h:Number = 50;

        public function Tooltip(){
            super();
            init();
        }
        
        public function set_bg(c:Number):void{
            bg_color = c;
        }
        
        public function get _height():Number{
            return (container.height);
        }
        
        private function draw():void{
            var _w:Number = (tf.width + (2 * padd));
            var _h:Number = (tf.height + (2 * padd));
            container.graphics.clear();
            container.graphics.beginFill(bg_color, 0.8);
            container.graphics.lineStyle(1, 2495750, 1, true);
            container.graphics.drawRoundRect(0, 0, _w, _h, 10);
            container.graphics.endFill();
        }
        
        public function setText(t:String, use_arrow:Boolean=false):void{
            if (t == ""){
                visible = false;
            } else {
                visible = true;
            }
            tf.text = t;
            if (tf.numLines == 1){
                tf.width = (tf.textWidth + 10);
            } else {
                tf.width = 200;
            }
            draw();
            if (arr){
                removeChild(arr);
                arr = null;
            };
            if (use_arrow){
                arr = new arrow();
                arr.x = ((container.width - arr.width) / 2);
                arr.y = container.height;
                arr.mouseEnabled = false;
                arr.mouseChildren = false;
                addChild(arr);
            }
            x = stage.mouseX;
            y = (stage.mouseY + 20);
            if ((y + height) > stage.stageHeight){
                y = ((stage.mouseY - 20) - height);
            }
            if ((x + width) > stage.stageWidth){
                x = (stage.mouseX - width);
            }
        }
        
        private function init():void{
            container = new Sprite();
            tf = new TextField();
            addChild(container);
            container.addChild(tf);
            tf.width = 200;
            tf.multiline = true;
            tf.wordWrap = true;
            tf.autoSize = TextFieldAutoSize.LEFT;
            var font:Font = new ComicSans();
            var format:TextFormat = new TextFormat();
            format.align = TextFormatAlign.CENTER;
            format.font = font.fontName;
            format.size = 14;
            format.color = 16706508;
            tf.defaultTextFormat = format;
            tf.embedFonts = true;
            tf.x = padd;
            tf.y = padd;
            mouseEnabled = false;
            mouseChildren = false;
        }

    }
}
