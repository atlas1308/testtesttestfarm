package classes.view.components.map.tools.collect_tools {
    import classes.utils.*;
    import classes.view.components.map.*;
    
    import mx.resources.ResourceManager;

    public class FertilizerTool extends Subtool {

        public const FERTILIZE:String = "fertilize";

        private var clicked:Boolean = false;
        private var plant_fertilized:Plant;
        private var fertilizer_used:Fertilizer;

        public function FertilizerTool(){
            super();
            TYPE = "fertilizer";
        }
        override public function allow():Boolean{
            if (!fertilizer_used){
                return (true);
            };
            if (plant){
                return (false);
            };
            return (false);
        }
        private function get fertilizer():Fertilizer{
            if (!target){
                return (null);
            };
            return ((target as Fertilizer));
        }
        override protected function mouseOut():void{
            hide_tip();
            if (fertilizer){
                fertilizer.clear_highlight();
            } else {
                if (plant){
                    plant.state = "clear";
                } else {
                    if (target){
                        target.state = "clear";
                    };
                    Cursor.hide();
                };
            };
        }
        private function get plant():Plant{
            var p:Plant = (target as Plant);
            if (p){
                if (p.can_be_fertilized()){
                    return (p);
                };
            };
            return (null);
        }
        override protected function mouseUp():void{
            if (((fertilizer_used) && (plant))){
                plant_fertilized = plant;
                action_name = FERTILIZE;
                confirm();
                if (!fertilizer_used.can_use()){
                    disable();
                    Cursor.hide();
                };
                if (!plant){
                    mouseOut();
                    mouseOver();
                };
            };
            if (fertilizer){
                fertilizer_used = fertilizer;
                Cursor.show(fertilizer_used.cursor_url, true, 5, 5);
            };
        }
        override public function action_confirmed(... _args):void{
        }
        override public function get_event_data():Object{
            var data:Object = new Object();
            data.fertilizer = fertilizer_used;
            data.plant = plant_fertilized;
            return (data);
        }
        
        override protected function mouseOver():void{
            if (fertilizer){
                tip(ResourceManager.getInstance().getString("message","fertilizer_used_message",[fertilizer.get_name()]));
                fertilizer.highlight_sack();
            }
            if (!(target as Processor)){
                if (fertilizer_used){
                    Cursor.show(fertilizer_used.cursor_url, true, 5, 5);
                    if (plant){
                        plant.state = "fertilize";
                    } else {
                        if (target){
                            target.state = "clear";
                        }
                    }
                }
            }
        }
        
        override protected function mouseMove():void{
        }
        
        override public function usable():Boolean{
            return true;
        }

    }
} 
