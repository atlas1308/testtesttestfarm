
package classes.view.components.map.tools.collect_tools {
    import classes.view.components.map.*;
    
    import mx.resources.ResourceManager;

    public class JamMachineTool extends MultiProcessorTool {

        public function JamMachineTool(){
            super();
            TYPE = "jam";
            switch_message = ResourceManager.getInstance().getString("message","click_to_select_jam_type_message");
        }
        override protected function default_message():Boolean{
            if (!multi_processor){
                return (false);
            };
            if (((!(multi_processor.can_refill_with(1))) && ((multi_processor.get_raw_materials(2) == 0)))){
                _tip("Add Honey in the jar");
                multi_processor.clear_highlight();
                return (true);
            };
            return (super.default_message());
        }
        override protected function get_tip_message(action:String, index:Number):String{
            if (!multi_processor){
                return (refill_message);
            };
            if (index == 1){
                if ((((multi_processor.get_raw_materials(2) == 0)) && ((multi_processor.get_raw_materials(1) == 3)))){
                    return ("Add Honey in the jar");
                };
                return ((("Add " + multi_processor.get_raw_material_name(1)) + " and Honey to make Jam"));
            };
            return ("Click to add Honey");
        }
        override protected function tip(s:String, obj:MapObject=null, color:Number=-1):void{
            super.tip(s, obj, color);
            if (multi_processor){
                tool_tip.y = (tool_tip.y - (50 * multi_processor.scale));
            };
        }
        override protected function get multi_processor():MultiProcessor{
            if ((target as JamMachine)){
                return ((target as MultiProcessor));
            };
            return (null);
        }

    }
} 
