package classes.view.components
{
    import classes.utils.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    
    import mx.resources.ResourceManager;

    public class NumericBar extends Sprite
    {
        public const SHOW_TOOLTIP:String = "showTooltip";
        protected var unit:String = "";
        public const HIDE_TOOLTIP:String = "hideTooltip";
        public var message:String;
        protected var value:String;

        public function NumericBar()
        {
            addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
            addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
        }

        protected function get_tool_tip_message() : String
        {
            return ResourceManager.getInstance().getString("message","user_has_coins_message",[value]);
        }

        public function update(value:Number) : void
        {
            var v:String = Algo.number_format(value);
            var textField:TextField = this.tf;
            textField.text = v.toString();
            if (unit != "")
            {
                tf.appendText(" " + unit);
            }
        }

        protected function get tf() : TextField
        {
            return new TextField();
        }

        protected function mouseMove(event:MouseEvent) : void
        {
            Cursor.hide();
            message = get_tool_tip_message();
            dispatchEvent(new Event(SHOW_TOOLTIP));
        }

        protected function mouseOut(event:MouseEvent) : void
        {
            dispatchEvent(new Event(HIDE_TOOLTIP));
        }

    }
}
