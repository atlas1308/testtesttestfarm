package classes.view.components.map.tools
{
    import classes.view.components.map.tools.shop_item_tools.*;
    
    import flash.display.*;
    import flash.events.*;

    public class UseShopItemTool extends Tool
    {
        private var tool:Tool;

        public function UseShopItemTool(value:Object)
        {
            super(value);
            TYPE = "useShopItem";
            tool = get_tool();
            tool.addEventListener(tool.CONFIRM_ACTION, confirmAction);
            tool.addEventListener(tool.ON_DISABLE, disableTool);
        }

        private function disableTool(event:Event) : void
        {
            disable();
        }

        private function get_tool() : Tool
        {
            var tool:Tool = new Tool();
            switch(data.kind)
            {
                case "chicken":
                {
                    tool = new AddChickenTool(data);
                    break;
                }
                case "sprinkler":
                {
                    tool = new InstallIrrigationTool(data);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return tool;
        }

        override public function remove() : void
        {
            tool.remove();
        }

        override public function mouse(state:String, target:Object) : void
        {
            tool.mouse(state, target);
        }

        private function confirmAction(event:Event) : void
        {
            action_name = event.target.action;
            dispatchEvent(new Event(CONFIRM_ACTION));
        }

        override public function set_bounds(a:Number, b:Number, c:Number) : void
        {
            tool.set_bounds(a, b, c);
        }

        override public function refresh_grid_size(value:Number) : void
        {
            tool.refresh_grid_size(value);
        }

        override public function init(a:Sprite, b:Sprite) : void
        {
            tool.init(a, b);
        }

        override public function activate() : void
        {
            tool.activate();
        }

        override public function action_confirmed(... args) : void
        {
            tool.action_confirmed.apply(null, args);
        }

        override public function get_event_data() : Object
        {
            return tool.get_event_data();
        }

    }
}
