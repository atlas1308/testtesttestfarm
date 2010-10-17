package classes.view.components.map.tools.collect_tools {
    import classes.view.components.map.*;
    
    import mx.resources.ResourceManager;

    public class RabbitTool extends ProcessorTool {

        public function RabbitTool(){
            super();
            TYPE = "rabbit";
            collect_message = ResourceManager.getInstance().getString("message","click_to_collect_message");
            feed_message = ResourceManager.getInstance().getString("message","click_to_feed_message_tip_message");;
            feed_message_after_click = ResourceManager.getInstance().getString("message","click_on_wheat_to_feed_the_rabbit_message");
            food_message = ResourceManager.getInstance().getString("message","click_to_feed_the_rabbit_message");
            time_message = ResourceManager.getInstance().getString("message","next_angora_hair_in_message");
            no_food_message = ResourceManager.getInstance().getString("message","plant_some_carrots_message");
            no_ready_food_message = ResourceManager.getInstance().getString("message","wait_for_carrots_to_grow_message");
        }
        override protected function get eater():Processor{
            if ((target as Rabbit)){
                return ((target as Processor));
            }
            return null;
        }

    }
} 
