
package classes.view.components.map.tools.collect_tools {
    import classes.view.components.*;
    import classes.view.components.map.*;
    
    import mx.resources.ResourceManager;

    public class WaterWellTool extends Subtool {

        public function WaterWellTool(){
            super();
            TYPE = "water_well_tool";
        }
        override protected function mouseUp():void{
            if (water_well){
                if (water_well.is_under_construction()){
                    confirm(Map.SHOW_UNDER_CONSTRUCTION_POPUP);
                } else {
                    confirm(Map.SHOW_UPGRADE_POPUP);
                    mouseOver();
                };
            };
        }
        override protected function mouseOut():void{
            hide_tip();
            if (((water_well) && (!(water_well.is_under_construction())))){
                water_well.hide_upgrade_level_anim();
            };
        }
        override public function remove():void{
            hide_tip();
        }
        override public function allow():Boolean{
            if (water_well){
                return (false);
            };
            return (true);
        }
        override protected function mouseDown():void{
            if ((target as WaterWell)){
            };
        }
        override public function get_event_data():Object{
            return (water_well);
        }
        
        override protected function mouseOver():void{
            if (water_well){
                if (water_well.is_under_construction()){
                    tip(ResourceManager.getInstance().getString("message","click_to_look_inside_materials_message",
                    	[water_well.get_name(),water_well.numObtainedMaterials(),water_well.numMaterials()]));
                } else {
                    water_well.show_upgrade_level_anim();
                    if (water_well.can_upgrade()){
                        tip(ResourceManager.getInstance().getString("message","click_to_upgrade_to_level_message",
                    		[water_well.get_name(),water_well.get_upgrade_level() + 1,water_well.get_next_upgrade_level_depth(),water_well.numObtainedMaterials()]));
                    } else {
                        tip(water_well.get_name());
                    }
                }
            }
        }
        
        override protected function tip(s:String, obj:MapObject=null, color:Number=-1):void{
            super.tip(s, obj, color);
            if (water_well){
                tool_tip.y = (tool_tip.y - (50 * water_well.scale));
            }
        }
        
        private function get water_well():WaterWell{
            return ((target as WaterWell));
        }

    }
} 
