package classes.view.components
{
    import classes.utils.*;
    
    import flash.events.*;
    import flash.text.*;
    
    import mx.resources.IResourceManager;
    import mx.resources.ResourceManager;

    public class Operations extends NumericBar
    {
        public var val:TextField;
        public var val1:TextField;
        public var val2:TextField;
        private var is_on:Boolean = false;
        public static const AUTOMATION_TOOL_OFF:String = "automationToolOff";
        public static const AUTOMATION_TOOL_ON:String = "automationToolOn";
		
		private var resourceManager:IResourceManager = ResourceManager.getInstance();
        public function Operations()
        {
            unit = ResourceManager.getInstance().getString("message","op_message");
            this.createChildren();
            this.init();
        }
        
        private var skin:OperationsSkin;
        public function createChildren():void {
        	this.skin = this.addChild(new OperationsSkin()) as OperationsSkin;
        	this.val = this.skin.val;
        	this.val1 = this.skin.val1;
        	this.val2 = this.skin.val2;
 
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

        override protected function get_tool_tip_message() : String
        {
            return "";
        }

        public function turn_off() : void
        {
            is_on = false;
            var txt:String = is_on ? resourceManager.getString("message","hide_automation_tip_message"):
            						resourceManager.getString("message","show_automation_tip_message");
            val2.text = txt;
            val1.text = txt;
        }

        override protected function get tf() : TextField
        {
            return val;
        }

        override protected function mouseMove(event:MouseEvent) : void
        {
            Cursor.hide();
            refresh_text();
        }

        private function init() : void
        {

            val.mouseEnabled = false;
            val1.mouseEnabled = false;
            val2.mouseEnabled = false;
            val2.visible = false;
            val1.visible = false;
            addEventListener(MouseEvent.CLICK, mouseClick);
            addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
            mouseOut(null);
            
        }

        override protected function mouseOut(event:MouseEvent) : void
        {
            val2.text = "";
            val1.text = "";
            val2.visible = false;
            val1.visible = false;
        }

        private function mouseOver(event:MouseEvent) : void
        {
            refresh_text();
        }

        private function refresh_text():void
        {
            var txt:String = is_on ? resourceManager.getString("message","hide_automation_tip_message"):
            						resourceManager.getString("message","show_automation_tip_message");
            val2.text = txt;
            val1.text = txt;
            val2.visible = true;
            val1.visible = true;
        }

    }
}
