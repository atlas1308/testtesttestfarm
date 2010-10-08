package classes.view.components
{
    import classes.utils.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    
    import mx.resources.ResourceManager;

    public class AutomationButton extends Sprite
    {
        public const SHOW_TOOLTIP:String = "showTooltip";
        public const HIDE_TOOLTIP:String = "hideTooltip";
        public var txt:TextField;
        private var is_on:Boolean = false;
        public var message:String;
        public const AUTOMATION_TOOL_OFF:String = "automationToolOff";
        public const AUTOMATION_TOOL_ON:String = "automationToolOn";

        public function AutomationButton()
        {
            mouseChildren = false;
            useHandCursor = true;
            buttonMode = true;
            addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
            addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
            addEventListener(MouseEvent.CLICK, mouseClick);
            refresh_text();
        }

        private function mouseClick(event:MouseEvent) : void
        {
            if (is_on)
            {
                dispatchEvent(new Event(AUTOMATION_TOOL_OFF));
                is_on = false;
            }
            else
            {
                dispatchEvent(new Event(AUTOMATION_TOOL_ON));
                is_on = true;
            }
            refresh_text();
        }

        private function mouseOut(event:MouseEvent) : void
        {
            return;
        }

        public function turn_off() : void
        {
            is_on = false;
            refresh_text();
        }

        private function refresh_text() : void
        {
            txt.text = is_on ? ResourceManager.getInstance().getString("message","exit_automation_message") : ResourceManager.getInstance().getString("message","enter_automation_message");
        }

        private function mouseMove(event:MouseEvent) : void
        {
            Cursor.hide();
        }

    }
}
