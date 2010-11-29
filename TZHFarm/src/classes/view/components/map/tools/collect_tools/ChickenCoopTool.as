package classes.view.components.map.tools.collect_tools {
    import classes.view.components.map.*;

    public class ChickenCoopTool extends ProcessorTool {

        public function ChickenCoopTool(){
            super();
            TYPE = "chicken_coop";
            /* collect_message = "Click to collect";
            feed_message = "Click to feed";
            feed_message_after_click = "Click on corn to refill";
            food_message = "Click to feed chickens";
            time_message = "Next egg in";
            no_food_message = "Plant some corn";
            no_ready_food_message = "Wait for corn to grow"; */
        }
        override protected function get eater():Processor{
            if ((target as ChickenCoop)){
                return ((target as Processor));
            };
            return (null);
        }

    }
} 
