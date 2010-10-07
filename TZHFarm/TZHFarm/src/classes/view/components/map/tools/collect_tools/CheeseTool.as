package classes.view.components.map.tools.collect_tools {
    import classes.view.components.map.*;
    
    import mx.resources.ResourceManager;

    public class CheeseTool extends ProcessorTool {

        public function CheeseTool(){
            super();
            TYPE = "cheese";
            collect_message = ResourceManager.getInstance().getString("message","click_to_collect_message");
            feed_message = "Click to refill";
            feed_message_after_click = "Click on milk to refill";
            food_message = "Click to refill the cheese machine";
            time_message = "Next cheese in";
            no_food_message = "Feed some cows";
            no_ready_food_message = "Wait for cows to milk";
        }
        override protected function get eater():Processor{
            if ((target as Cheese)){
                return ((target as Processor));
            };
            return (null);
        }

    }
}
