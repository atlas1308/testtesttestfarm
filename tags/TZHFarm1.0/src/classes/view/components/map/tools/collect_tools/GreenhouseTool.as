
package classes.view.components.map.tools.collect_tools {
    import classes.view.components.*;
    import classes.view.components.map.*;
    
    import mx.resources.ResourceManager;

    public class GreenhouseTool extends Subtool {

        public function GreenhouseTool(){
            super();
            TYPE = "greenhouse";
        }
        override protected function mouseUp():void{
            if (greenhouse){
                if (greenhouse.is_under_construction()){
                    confirm(Map.SHOW_UNDER_CONSTRUCTION_POPUP);
                } else {
                    greenhouse.toggle();
                    mouseOver();
                };
            };
        }
        override protected function mouseOut():void{
            hide_tip();
        }
        override public function remove():void{
            hide_tip();
        }
        override protected function mouseDown():void{
            if ((target as Greenhouse)){
            };
        }
        override public function get_event_data():Object{
            return (greenhouse);
        }
        override protected function mouseOver():void{
            if (greenhouse){
                if (greenhouse.is_under_construction()){
                    tip(ResourceManager.getInstance().getString("message","click_to_look_inside_materials_message",
                		[greenhouse.get_name(),greenhouse.numObtainedMaterials(),greenhouse.numMaterials()]));
                } else {
                    if (greenhouse.is_opened()){
                        tip(ResourceManager.getInstance().getString("message","click_to_close_message",[greenhouse.get_name()]));
                    } else {
                        tip(ResourceManager.getInstance().getString("message","click_to_look_inside_message",[greenhouse.get_name()]));
                    }
                }
            }
        }
        
        override public function allow():Boolean{
            if (greenhouse){
                return (false);
            };
            return (true);
        }
        private function get greenhouse():Greenhouse{
            return ((target as Greenhouse));
        }

    }
} 
