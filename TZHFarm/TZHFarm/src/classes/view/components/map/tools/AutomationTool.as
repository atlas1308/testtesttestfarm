package classes.view.components.map.tools
{
    import classes.view.components.map.*;
    
    import mx.resources.ResourceManager;

    public class AutomationTool extends Tool
    {
        public const TOGGLE_AUTOMATION:String = "toggleAutomation";
        private var last_processor:CollectObject;
        private var button_mode:Boolean = false;
        private var redirect:Boolean = false;

        public function AutomationTool()
        {
            return;
        }

        override protected function mouseOut() : void
        {
            if (button_mode)
            {
                redirect = true;
                mouseOver();
                redirect = false;
            }
            else
            {
                hide_tip();
            }
        }

        override protected function mouseUp() : void
        {
            if (!processor)
            {
                return;
            }
            if (processor.is_under_construction())
            {
                return;
            }
            if (processor.toggler_over())
            {
                confirm(TOGGLE_AUTOMATION);
                return;
            }
        }

        private function get processor() : CollectObject
        {
            if (button_mode && last_processor)
            {
                return last_processor;
            }
            if (!target)
            {
                return null;
            }
            if (!(target as IProcessor))
            {
                return null;
            }
            return target as CollectObject;
        }

        override public function remove() : void
        {
            var collectObject:CollectObject = null;
            hide_tip();
            var index:Number  = 0;
            while (index < map_objects.numChildren)
            {
               collectObject = map_objects.getChildAt(index) as CollectObject;
               if (collectObject as IProcessor)
                {
                    collectObject.hide_toggler();
                }
                index=index+1;
            }
 
        }

        override public function action_confirmed(... args) : void
        {
            if (!processor)
            {
                return;
            }
            if (processor.is_automatic())
            {
                processor.turn_off_automation();
            }
            else
            {
                processor.turn_on_automation();
            }
            mouseOver();
        }

        override protected function mouseOver() : void
        {
            if (!processor)
            {
                return;
            }
            if (processor.is_under_construction())
            {
                return;
            }
            if (processor.toggler_over())
            {
                if (!button_mode)
                {
                    button_mode = true;
                    last_processor = processor;
                    processor.toggler_button_mode();
                }
                if (processor.is_automatic())
                {
                    return tip(ResourceManager.getInstance().getString("message","click_to_switch_off_automation_message",[processor.get_name()]), processor);
                }
                return tip(ResourceManager.getInstance().getString("message","click_to_switch_on_automation_message",[processor.get_name()]), processor);
            }
            else
            {
                processor.toggler_normal_mode();
                last_processor = null;
                button_mode = false;
            }
            hide_tip();
        }

        override public function activate() : void
        {
            var collectObject:CollectObject = null;
            var index:Number = 0;
            while (index < map_objects.numChildren)
            {
                collectObject = map_objects.getChildAt(index) as CollectObject;
                if (collectObject as IProcessor)
                {
                    collectObject.show_toggler();
                }
                index=index+1;
            }
        }

        override protected function mouseMove() : void
        {
            mouseOver();
        }

        override public function get_event_data() : Object
        {
            switch(action_name)
            {
                case TOGGLE_AUTOMATION:
                {
                    return processor;
                }
                default:
                {
                    return {};
                    break;
                }
            }
        }
    }
}
