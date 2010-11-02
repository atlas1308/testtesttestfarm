package classes.view.components.map.tools.collect_tools {
    import classes.view.components.map.*;

    public class CowTool extends ProcessorTool {

        public function CowTool(){
            super();
            TYPE = "cow";
        }
        
        override protected function get eater():Processor{
            if (target as Cow){
                return target as Processor;
            }
            return null;
        }

    }
} 
