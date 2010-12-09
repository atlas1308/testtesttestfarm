package classes.view.components {
    import flash.display.*;
    import flash.text.*;

    public class Tooltip extends Sprite {
        private var container:Sprite;
        private var bg_color:Number = 4925711;
        private var padd:Number = 4;
        private var tf:TextField;

        public function Tooltip(){
            super();
            init();
        }
        
        public function set_bg(value:Number):void{
            bg_color = value;
        }
        
        private function draw():void{
            var ww:Number = tf.width + (2 * padd);
            var hh:Number = tf.height + (2 * padd);
            container.graphics.clear();
            container.graphics.beginFill(bg_color, 0.8);
            container.graphics.lineStyle(1, 2495750, 1, true);
            container.graphics.drawRoundRect(0, 0, ww, hh, 10);
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
