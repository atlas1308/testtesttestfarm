package classes.view.components.map.tools.collect_tools {
    import classes.view.components.map.*;
    
    import mx.resources.ResourceManager;

    public class ChristmasTreeTool extends Subtool {

        public static const SHOW_CHRISTMAS_PRESENTS:String = "showChristmasPresents";

        public function ChristmasTreeTool(){
            super();
            TYPE = "christmas_tree";
        }
        
        override protected function mouseUp():void{
            if (tree){
                if (((tree.has_lights()) && (tree.lights_over()))){
                    tree.change_animation();
                } else {
                    if (tree.is_christmas()){
                        confirm(SHOW_CHRISTMAS_PRESENTS);
                    }
                }
            }
        }
        
        override public function allow():Boolean{
            if (tree){
                return (false);
            };
            return (super.allow());
        }
        
        override public function remove():void{
            hide_tip();
            if (tree){
                tree.clear_highlight();
            }
        }
        
        override protected function mouseMove():void{
            mouseOver();
        }
        
        override protected function mouseOut():void{
            hide_tip();
            if (tree){
                tree.clear_highlight();
            }
        }
        
        override protected function mouseOver():void{
            if (tree){
                if (((tree.lights_over()) && (tree.has_lights()))){
                    tip(ResourceManager.getInstance().getString("meessage","click_to_change_animation_message"));
                    tree.clear_highlight();
                } else {
                    if (tree.is_christmas()){
                        tip(ResourceManager.getInstance().getString("message","click_to_open_your_present_message"));
                        tree.highlight_presents();
                    } else {
                        tip(ResourceManager.getInstance().getString("message","get_present_25_message"));
                        tree.highlight_presents(12827065);
                    }
                }
            }
        }
        
        private function get tree():ChristmasTree{
            return ((target as ChristmasTree));
        }

    }
} 
