package classes.view.components.map.tools.collect_tools {
    import classes.view.components.map.*;

    public class DecorationTool extends Subtool {

        public function DecorationTool(){
            super();
            TYPE = "deco";
        }
        
        override protected function mouseOut():void{
            hide_tip();
        }
        
        override protected function mouseOver():void{
            if (target as Decoration){
                tip(target.get_name());
            }
        }
        
        override public function remove():void{
            hide_tip();
        }
        
        override public function allow():Boolean{
            if (target as Decoration){
                return false;
            }
            return true;
        }
        
        override protected function mouseDown():void{
            if ((target as Decoration)){
                trace(target, target.map_unique_id);
            }
        }
    }
} 
