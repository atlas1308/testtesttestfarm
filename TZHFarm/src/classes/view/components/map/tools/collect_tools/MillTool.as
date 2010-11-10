
package classes.view.components.map.tools.collect_tools {
    import classes.view.components.map.*;
    
    import mx.resources.ResourceManager;

    public class MillTool extends ProcessorTool {

        public function MillTool(){
            super();
            TYPE = "mill";
            collect_message = ResourceManager.getInstance().getString("message","click_to_collect_message");
            feed_message = ResourceManager.getInstance().getString("message","click_to_refill_message");
            feed_message_after_click = ResourceManager.getInstance().getString("message","click_on_wheat_to_refill_message");
            food_message = ResourceManager.getInstance().getString("message","click_to_refill_the_flour_mill_message");
            time_message = ResourceManager.getInstance().getString("message","next_flour_in_message");
            no_food_message = ResourceManager.getInstance().getString("message","plant_some_wheat_message");
            no_ready_food_message = ResourceManager.getInstance().getString("message","wait_for_wheat_to_grow_message");
        }
        override protected function get eater():Processor{
            if (target as Mill){
                return target as Processor;
            }
            return null;
        }

    }
} 
