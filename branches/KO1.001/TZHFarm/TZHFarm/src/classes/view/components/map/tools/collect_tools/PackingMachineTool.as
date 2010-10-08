
package classes.view.components.map.tools.collect_tools {
    import classes.view.components.map.*;
    
    import mx.resources.ResourceManager;

    public class PackingMachineTool extends MultiProcessorTool {

        public function PackingMachineTool(){
            super();
            TYPE = "packing_machine";
            switch_message = ResourceManager.getInstance().getString("message","click_to_select_pack_type_message");
        }
        override protected function get multi_processor():MultiProcessor{
            if ((target as PackingMachine)){
                return ((target as MultiProcessor));
            };
            return (null);
        }

    }
} 
