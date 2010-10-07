package classes.view.components.map.tools.collect_tools {
    import classes.view.components.map.*;
    
    import mx.resources.ResourceManager;

    public class HiveTool extends ProcessorTool {

        public function HiveTool(){
            super();
            TYPE = "bees";
            collect_message = ResourceManager.getInstance().getString("message","click_to_collect_message");
            feed_message = "";
            feed_message_after_click = "";
            food_message = "";
            time_message = ResourceManager.getInstance().getString("message","next_honey_in_message");
            no_food_message = ResourceManager.getInstance().getString("message","plant_some_clover_message");
            no_ready_food_message = ResourceManager.getInstance().getString("message","wait_for_clover_to_grow_message");
        }
        override protected function mouseUp():void{
            if (eater){
                if (eater.is_automatic()){
                    return;
                };
                if (can_collect()){
                    action_name = COLLECT_PRODUCT;
                    confirm();
                };
            };
        }
        override protected function mouseOver():void{
            if (eater){
                if (eater.is_automatic()){
                    return (_tip(ResourceManager.getInstance().getString("message","automation_on_message")));
                };
                if (can_collect()){
                    eater.highlight_collect();
                    return _tip(collect_message);
                };
                eater.clear_highlight();
                if (!is_working()){
                    if (Hive(eater).bees_are_flying()){
                        return _tip(ResourceManager.getInstance().getString("message","wait_for_bees_to_return_message"));
                    };
                    if (no_clover()){
                        return _tip(ResourceManager.getInstance().getString("message","plant_some_clover_message"));
                    };
                    if (no_blossomed_clover()){
                        return (_tip(ResourceManager.getInstance().getString("message","wait_for_clover_to_blossom_message")));
                    };
                };
            };
            if (eater){
                eater.clear_highlight();
            };
            _tip("");
        }
        private function no_clover():Boolean{
            var plant:Plant;
            var i:Number = 0;
            while (i < map_objects.numChildren) {
                plant = (map_objects.getChildAt(i) as Plant);
                if (!plant){
                } else {
                    if (plant.id == eater.raw_material_id){
                        if (((plant.can_be_fertilized()) || (((((!(plant.is_pollinated())) && (!(plant.is_marked_for_pollination())))) && (plant.is_ready()))))){
                            return (false);
                        }
                    }
                }
                i++;
            }
            return (true);
        }
        
        override protected function get eater():Processor{
            if ((target as Hive)){
                return ((target as Processor));
            }
            return null;
        }
        
        private function no_blossomed_clover():Boolean{
            var plant:Plant;
            var i:Number = 0;
            while (i < map_objects.numChildren) {
                plant = (map_objects.getChildAt(i) as Plant);
                if (!plant){
                } else {
                    if (plant.id == eater.raw_material_id){
                        if (((((!(plant.is_pollinated())) && (!(plant.is_marked_for_pollination())))) && (plant.is_ready()))){
                            return (false);
                        };
                    };
                };
                i++;
            };
            return (true);
        }

    }
} 
