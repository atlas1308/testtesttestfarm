package classes.view.components.map.tools.collect_tools {
    import classes.view.components.map.*;
    
    import mx.resources.ResourceManager;

    public class KetchupTool extends ProcessorTool {

        public function KetchupTool(){
            super();
            TYPE = "ketchup";
            collect_message = ResourceManager.getInstance().getString("message","click_to_collect_message");
            feed_message = ResourceManager.getInstance().getString("message","click_to_refill_message");
            feed_message_after_click = ResourceManager.getInstance().getString("message","click_on_tomatoes_to_refill_message");
            food_message = ResourceManager.getInstance().getString("message","click_to_refill_the_ketchup_machine_message");
            time_message = ResourceManager.getInstance().getString("message","next_ketchup_in");
            no_food_message = ResourceManager.getInstance().getString("message","plant_some_tomatoes_message");
            no_ready_food_message = ResourceManager.getInstance().getString("message","wait_for_tomatoes_to_grow_message");
        }
        override protected function get eater():Processor{
            if (target as Ketchup){
                return target as Processor;
            }
            return null;
        }

    }
} 
