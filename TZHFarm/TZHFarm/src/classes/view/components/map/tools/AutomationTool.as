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
            return;
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
            return;
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
            var _loc_2:CollectObject = null;
            hide_tip();
            var _loc_1:Number  = 0;
            while (_loc_1 < map_objects.numChildren)
            {
                
                _loc_2 = map_objects.getChildAt(_loc_1) as CollectObject;
               if (_loc_2 as IProcessor)
                {
                    _loc_2.hide_toggler();
                }
                _loc_1=_loc_1+1;
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
            return;
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
                {;
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
            var _loc_2:CollectObject = null;
            var _loc_1:Number = 0;
            while (_loc_1 < map_objects.numChildren)
            {
                
                _loc_2 = map_objects.getChildAt(_loc_1) as CollectObject;
                if (_loc_2 as IProcessor)
                {
                    _loc_2.show_toggler();
                }
                _loc_1=_loc_1+1;
                
            }
            var i:Number =1;

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
