package classes.view.components.map.tools.collect_tools {
    import classes.utils.*;
    import classes.view.components.map.*;
    
    import flash.events.*;
    
    import mx.resources.ResourceManager;

    public class TreeTool extends Subtool {

        public function TreeTool(){
            super();
            TYPE = "tree";
            action_name = COLLECT_PRODUCT;
        }
        override protected function mouseUp():void{
            if (((tree) && (tree.is_ready()))){
                dispatchEvent(new Event(CONFIRM_ACTION));
                disable();
            }
        }
        
        override protected function mouseOut():void{
            hide_tip();
            if (tree){
                tree.clear_highlight();
            }
        }
        
        override public function usable():Boolean{
            if (((tree) && (tree.is_ready()))){
                return (true);
            };
            return (false);
        }
        override protected function mouseOver():void{
            if (tree){
                Cursor.hide();
                tree.highlight_collect();
                if (tree.is_ready()){
                    tip(ResourceManager.getInstance().getString("message","click_to_harvest_message",[tree.get_name()]));
                } else {
                    tip(ResourceManager.getInstance().getString("message","plant_grow_message",[tree.get_name(), tree.product_percent()]));
                }
            }
        }
        
        private function get tree():Tree{
            if ((((target as Tree)) && (target.usable))){
                return target as Tree;
            }
            return null;
        }
        
        override public function get_event_data():Object{
            return tree;
        }

    }
} 
