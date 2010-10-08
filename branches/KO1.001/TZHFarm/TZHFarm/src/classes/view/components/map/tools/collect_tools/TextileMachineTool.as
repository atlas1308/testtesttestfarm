
package classes.view.components.map.tools.collect_tools {
    import classes.view.components.map.*;
    
    import mx.resources.ResourceManager;

    public class TextileMachineTool extends MultiProcessorTool {

        public function TextileMachineTool(){
            super();
            TYPE = "textile";
            switch_message = ResourceManager.getInstance().getString("message","click_to_select_sweater_type_message");
        }
        
        override protected function tip(s:String, obj:MapObject=null, color:Number=-1):void{
            super.tip(s, obj, color);
            if (multi_processor){
                tool_tip.y = (tool_tip.y - (50 * multi_processor.scale));
            }
        }
        
        override protected function get multi_processor():MultiProcessor{
            if (target as TextileMachine){
                return target as MultiProcessor;
            }
            return null;
        }

    }
} 
