package 
{
    import classes.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.system.*;
    import flash.text.*;

    dynamic public class Log extends Object
    {
        public static var memory:TextField;
        public static var tf:TextField;
        public static var container:Sprite;
        public static var stage:Stage;

        public function Log()
        {
            return;
        }

        public static function add(value:String):void
        {
        	//trace("param1 " + value.toString());
            /* tf.appendText(Algo.log_time() + param1 + "\n");
            tf.scrollV = tf.maxScrollV;
            stage.setChildIndex(container, stage.numChildren--);
            return; */
            //trace("params " + param1.toString());
        }

        public static function init(param1:Object):void
        {
            /* container = new Sprite();
            container.name = "log";
            stage = param1 as Stage;
            memory = new TextField();
            memory.width = 200;
            memory.height = 20;
            tf = new TextField();
            tf.width = 400;
            tf.height = 200;
            tf.y = 30;
            tf.background = true;
            tf.backgroundColor = 13421772;
            var _loc_2:* = new TextFormat();
            _loc_2.size = 14;
            _loc_2.font = "Monaco";
            tf.defaultTextFormat = _loc_2;
            memory.defaultTextFormat = _loc_2;
            container.visible = false;
            container.addChild(tf);
            container.addChild(memory);
            stage.addChild(container);
            container.setChildIndex(tf, stage.numChildren--);
            return; */
        }

        public static function toggle() : void
        {
            /* container.visible = !container.visible;
            if (container.visible)
            {
                stage.addEventListener(Event.ENTER_FRAME, enterFrame);
            }
            else
            {
                stage.removeEventListener(Event.ENTER_FRAME, enterFrame);
            }
            return; */
        }

        public static function enterFrame(event:Event) : void
        {
            /* memory.text = Algo.prep_size(System.totalMemory) + " - " + Algo.prep_size(Cache.size());
            stage.setChildIndex(container, stage.numChildren--);
            return; */
        }

    }
}
