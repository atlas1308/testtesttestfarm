package classes.view.components
{
    import fl.motion.easing.*;
    import fl.transitions.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.text.*;
    
    import tzh.DisplayUtil;

    public class Confirmation extends Sprite
    {
        private var data:Object;
        private var y_tween:Tween;
        private var alpha_tween:Tween;
		public function Confirmation(value:Object)
        {
            this.data = value;
            this.addEventListener(Event.ADDED_TO_STAGE, init);
        } 

        private function init(event:Event) : void
        {
        	this.removeEventListener(Event.ADDED_TO_STAGE, init);
            var minusTextField:TextField = null;
            var plusTextField:TextField = null;
            minusTextField = create_tf(data.minus?data.minus:"");
            plusTextField = create_tf(data.plus?data.plus:"");// bug
            addChild(minusTextField);
            addChild(plusTextField);
            mouseEnabled = false;
            mouseChildren = false;
            plusTextField.x = minusTextField.width + 10;
            var xx:Number = data.target ? (data.target.x) : (mouseX);
            var yy:Number = data.target ? (data.target.y) : (mouseY);
            x = xx - width / 2;
            y = yy - height;
            set_filter(minusTextField, 14169122);
            set_filter(plusTextField, 26112);
        }

        public function start() : void
        {
            alpha_tween = new Tween(this, "alpha", Exponential.easeInOut, 1, 0, data.duration, true);
            y_tween = new Tween(this, "y", Linear.easeInOut, y, y - 100, data.duration, true);
            y_tween.addEventListener(TweenEvent.MOTION_FINISH, finished);
        }

        private function set_filter(tf:TextField, a:Number) : void
        {
            var filter:DropShadowFilter = new DropShadowFilter(0, 0, a, 1, 4, 4, 10, 1, false, false, false);
            tf.filters = [filter];
        }

        private function create_tf(value:String) : TextField
        {
            var tf:TextField = new TextField();
            tf.autoSize = TextFieldAutoSize.LEFT;
            tf.selectable = false;
            var hevfont:Font = new Helvetica();
            var textFormat:TextFormat= new TextFormat();
            textFormat.font = hevfont.fontName;
            textFormat.size = 15;
            textFormat.bold = true;
            textFormat.color = 16777215;
            textFormat.align = TextFormatAlign.CENTER;
            tf.defaultTextFormat = textFormat;
            tf.embedFonts = true;
            tf.text = value;
            return tf;
        }

        private function finished(event:TweenEvent) : void
        {
        	alpha_tween.stop();
        	y_tween.stop();
        	y_tween.removeEventListener(TweenEvent.MOTION_FINISH, finished);
        	DisplayUtil.removeAllChildren(this);
            parent.removeChild(this);
        }

    }
}
