
package classes.view.components.map.tools.collect_tools {
    import classes.view.components.map.*;
    
    import mx.resources.ResourceManager;

    public class MultiMillTool extends MultiProcessorTool {

        public function MultiMillTool(){
            super();
            TYPE = "multi_mill";
            switch_message = ResourceManager.getInstance().getString("message","click_to_select_flour_type_message");
        }
        override protected function get multi_processor():MultiProcessor{
            if (target as MultiMill){
                return target as MultiProcessor;
            }
            return null;
        }

    }
} 
