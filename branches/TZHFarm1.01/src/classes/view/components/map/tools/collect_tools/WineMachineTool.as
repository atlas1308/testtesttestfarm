
package classes.view.components.map.tools.collect_tools {
    import classes.view.components.map.*;
    
    import mx.resources.ResourceManager;

    public class WineMachineTool extends ProcessorTool {

        public function WineMachineTool(){
            super();
            TYPE = "cheese";
            collect_message = ResourceManager.getInstance().getString("message","click_to_collect_message");
            feed_message = ResourceManager.getInstance().getString("message","click_to_refill_message");
            feed_message_after_click = ResourceManager.getInstance().getString("message","click_on_grapes_to_refill_message");
            food_message = ResourceManager.getInstance().getString("message","click_to_refill_wine_machine");
            time_message = ResourceManager.getInstance().getString("message","nex_wine_in_message");
            no_food_message = ResourceManager.getInstance().getString("message","harvest_some_grapes_message");
            no_ready_food_message = ResourceManager.getInstance().getString("message","wait_for_grapes_to_grow");
        }
        override protected function get eater():Processor{
            if ((target as WineMachine)){
                return ((target as Processor));
            };
            return (null);
        }

    }
} 
