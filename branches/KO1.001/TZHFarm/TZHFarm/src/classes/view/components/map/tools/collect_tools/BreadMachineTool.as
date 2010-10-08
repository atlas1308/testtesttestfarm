package classes.view.components.map.tools.collect_tools {
    import classes.utils.*;
    import classes.view.components.map.*;

    public class BreadMachineTool extends MultiProcessorTool {

        public function BreadMachineTool(){
            super();
            TYPE = "bread";
            switch_message = "";
        }
        override protected function default_message():Boolean{
            if (!multi_processor){
                return (false);
            };
            var needed:Array = multi_processor.get_needed_raw_materials();
            if (needed.length){
                _tip((("Add " + Algo.enumerate(needed)) + " to make Bread"));
            } else {
                _tip("");
            };
            multi_processor.clear_highlight();
            return (true);
        }
        override protected function tip(s:String, obj:MapObject=null, color:Number=-1):void{
            super.tip(s, obj, color);
            if (multi_processor){
                tool_tip.y = (tool_tip.y - (30 * multi_processor.scale));
            };
        }
        override protected function get multi_processor():MultiProcessor{
            if ((target as BreadMachine)){
                return ((target as MultiProcessor));
            };
            return (null);
        }
        override protected function default_mouseUp():void{
        }

    }
} 
