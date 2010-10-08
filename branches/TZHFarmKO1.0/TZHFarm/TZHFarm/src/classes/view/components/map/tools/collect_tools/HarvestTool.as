package classes.view.components.map.tools.collect_tools {
    import classes.utils.*;
    import classes.view.components.map.*;
    
    import flash.display.*;
    import flash.events.*;
    
    import mx.resources.ResourceManager;

    public class HarvestTool extends Subtool {

        public function HarvestTool(){
            super();
            TYPE = "harvest";
            action_name = COLLECT_PRODUCT;
        }
        override public function init(tool_cont:Sprite, map_objects:Sprite):void{
            super.init(tool_cont, map_objects);
            tip_icon = new Waterdrop();
        }
        override protected function mouseOut():void{
            hide_tip();
            if (target){
                show_above_objects(target);
                target.state = "clear";
            };
        }
        override public function action_confirmed(... _args):void{
            map_objects.removeChild(plant);
            var soil:MapObject = new MapObject(_args[0]);
            soil.grid_size = map_grid_size;
            map_objects.addChild(soil);
            disable();
        }
        override protected function mouseUp():void{
            if (((plant) && (plant.is_ready()))){
                dispatchEvent(new Event(CONFIRM_ACTION));
                disable();
            };
        }
        override public function get_event_data():Object{
            return (plant);
        }
        override protected function mouseOver():void{
            if (plant){
                hide_above_objects(plant);
                Cursor.hide();
                plant.state = "collect_over";
                if (plant.has_irrigation()){
                    use_tip_icon = true;
                } else {
                    use_tip_icon = false;
                };
                if (plant.is_ready()){
                    if (plant.is_pollinated()){
                        tip(ResourceManager.getInstance().getString("message","click_to_harvest_pollinated_message",[plant.get_name()]));
                    } else {
                        tip(ResourceManager.getInstance().getString("message","click_to_harvest_message",[plant.get_name()]));
                    }
                } else {
                    tip(ResourceManager.getInstance().getString("message","plant_grow_message",[plant.get_name(),plant.product_percent()]));
                }
            }
        }
        private function get plant():Plant{
            if ((((target as Plant)) && (target.usable))){
                return ((target as Plant));
            }
            return null;
        }
        override public function usable():Boolean{
            if (((plant) && (plant.is_ready()))){
                return (true);
            }
            return false;
        }

    }
}
