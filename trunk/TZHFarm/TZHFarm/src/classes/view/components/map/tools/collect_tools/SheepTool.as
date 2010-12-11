package classes.view.components.map.tools.collect_tools {
    import classes.view.components.map.*;
    
    import mx.resources.ResourceManager;

    public class SheepTool extends ProcessorTool {

        public function SheepTool(){
            super();
            TYPE = "sheep";
            collect_message = ResourceManager.getInstance().getString("message","click_to_collect_message");
            feed_message = ResourceManager.getInstance().getString("message","click_to_feed_message_tip_message");
            feed_message_after_click = ResourceManager.getInstance().getString("message","click_on_wheat_to_feed_sheep_message");
            food_message = ResourceManager.getInstance().getString("message","click_to_feed_the_sheep_message");;
            time_message = ResourceManager.getInstance().getString("message","next_wool_in_message");
            no_food_message = ResourceManager.getInstance().getString("message","plant_some_wheat_message");
            no_ready_food_message = ResourceManager.getInstance().getString("message","wait_for_wheat_to_grow_message");
        }
        override protected function get eater():Processor{
            if (target as Sheep){
                return target as Sheep;
            }
            return null;
        }
    }
} 
