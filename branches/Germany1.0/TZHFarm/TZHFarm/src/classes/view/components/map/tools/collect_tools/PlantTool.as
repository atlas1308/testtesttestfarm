
package classes.view.components.map.tools.collect_tools {
    import classes.utils.*;
    import classes.view.components.map.*;
    
    import flash.display.*;
    import flash.events.*;
    
    import mx.resources.ResourceManager;

    public class PlantTool extends Subtool {

        private const ADD_PLANT:String = "addPlant";
        private const SHOW_SHOP_AND_ADD_PLANT:String = "showShopAndAddPlant";

        private var has_soil_to_plant:Boolean = false;
        private var soil_to_plant:MapObject;
        private var plant:Plant;

        public function PlantTool(){
            super();
            TYPE = "plant";
            action_name = SHOW_SHOP_AND_ADD_PLANT;
        }
        
        override protected function mouseUp():void{
            if (!plant){
                if (((soil) && (soil.usable))){
                    action_name = SHOW_SHOP_AND_ADD_PLANT;
                    dispatchEvent(new Event(CONFIRM_ACTION));
                }
            } else {
                if (((soil) && (soil.usable))){
                    soil_to_plant = soil;
                    action_name = ADD_PLANT;
                    dispatchEvent(new Event(CONFIRM_ACTION));
                    activate();
                }
            }
        }
        
        override protected function mouseOut():void{
            hide_tip();
            if (target){
                target.state = "clear";
            };
        }
        
        override protected function mouseMove():void{
            show_cursor();
        }
        
        override public function refresh_grid_size(s:Number):void{
            super.refresh_grid_size(s);
            if (plant){
                plant.grid_size = s;
            }
        }
        
        override public function remove():void{
        }
        
        override public function allow():Boolean{
            if (soil){
                return (false);
            }
            return (true);
        }
        
        override public function init(tool_cont:Sprite, map_objects:Sprite):void{
            super.init(tool_cont, map_objects);
            tip_icon = new Waterdrop();
        }
        
        override public function activate():void{
            super.activate();
            if (!data){
                return;
            };
            clear();
            plant = new Plant(data);
            plant.grid_size = map_grid_size;
            Cursor.show(data.cursor, true, 5, 5);
            if (has_soil_to_plant){
                has_soil_to_plant = false;
                action_name = ADD_PLANT;
                dispatchEvent(new Event(CONFIRM_ACTION));
                activate();
            }
        }
        
        private function get soil():MapObject{
            if ((((target as MapObject)) && ((target.type == "soil")))){
                return ((target as MapObject));
            };
            return (null);
        }
        
        override public function get_event_data():Object{
            switch (action_name){
                case SHOW_SHOP_AND_ADD_PLANT:
                    return (soil);
                case ADD_PLANT:
                    return ({
                        plant:plant,
                        soil:soil_to_plant
                    });
            };
            return ({});
        }
        
        override protected function mouseOver():void{
            show_cursor();
            if (target){
                target.state = "collect_over";
            };
            if (soil){
                if (soil.has_irrigation()){
                    use_tip_icon = true;
                } else {
                    use_tip_icon = false;
                };
            };
            if (!plant){
                if (((soil) && (soil.usable))){
                    tip(ResourceManager.getInstance().getString("message","click_to_plant_message"));
                };
                if (((soil) && (!(soil.usable)))){
                    tip(ResourceManager.getInstance().getString("message","planting_message"));
                };
            } else {
                if (((soil) && (soil.usable))){
                    tip(ResourceManager.getInstance().getString("message","click_to_plant_name_message",[plant.get_name()]));
                };
                if (((soil) && (!(soil.usable)))){
                    tip(ResourceManager.getInstance().getString("message","planting_message"));
                };
            };
        }
        
        override public function action_confirmed(... _args):void{
            switch (action_name){
                case SHOW_SHOP_AND_ADD_PLANT:
                    data = _args[0];
                    if (data.soil_to_plant){
                        has_soil_to_plant = true;
                        soil_to_plant = data.soil_to_plant;
                    };
                    activate();
                    break;
                case ADD_PLANT:
                    map_objects.addChild(plant);
                    plant.grid_x = soil_to_plant.grid_x;
                    plant.grid_y = soil_to_plant.grid_y;
                    plant.state = "clear";
                    plant.start();
                    map_objects.removeChild(soil_to_plant);
                    activate();
                    break;
            }
        }
        
        private function show_cursor():void{
            if (((((!(target)) || (soil))) && (plant))){
                Cursor.show(data.cursor, true, 5, 5);
            } else {
                Cursor.hide();
            };
        }

    }
} 
