
package classes.view.components.map.tools.collect_tools {
    import classes.view.components.map.*;
    import flash.utils.*;
    import classes.view.components.*;

    public class MultiProcessorTool extends Subtool {

        protected var current_message:String;
        protected var switch_message:String = "Click to select";
        protected var interval:Number;
        protected var refill_material:Number;
        protected var collect_message:String = "Click to collect";
        protected var refill_message:String = "Click to refill";

        public function MultiProcessorTool(){
            super();
        }
        override public function remove():void{
            stop_timer();
        }
        protected function stop_timer():void{
            clearInterval(interval);
        }
        override public function allow():Boolean{
            if (multi_processor){
                return (false);
            };
            if (super.allow()){
                hide_tip();
            };
            return (super.allow());
        }
        protected function get multi_processor():MultiProcessor{
            return ((target as MultiProcessor));
        }
        protected function show_timer():void{
            if (!is_working()){
                stop_timer();
                mouseOver();
                return;
            };
            if (!multi_processor){
                stop_timer();
                return;
            };
            var msg:String = current_message;
            if (msg != ""){
                msg = (msg + "\n");
            };
            msg = (msg + (((multi_processor.product_name() + ": ") + multi_processor.product_percent()) + "% Ready"));
            tip(msg);
        }
        override protected function mouseMove():void{
            mouseOver();
        }
        protected function default_message():Boolean{
            if (!multi_processor){
                return (false);
            };
            if (multi_processor.can_refill_with(1)){
                multi_processor.highlight_refill(1);
                _tip(get_tip_message("refill", 1));
                return (true);
            };
            return (false);
        }
        override protected function mouseOver():void{
            if (!multi_processor){
                return (_tip(""));
            };
            if (multi_processor.is_under_construction()){
                tip((((((multi_processor.get_name() + "\n") + multi_processor.numObtainedMaterials()) + "/") + multi_processor.numMaterials()) + " materials"));
                return;
            };
            if (multi_processor.switch_over()){
                multi_processor.highlight_switch();
                return (_tip(switch_message));
            };
            if (multi_processor.is_automatic()){
                multi_processor.highlight_automation_areas(12827065);
                return (_tip("Automation ON"));
            };
            if (((multi_processor.collect_over()) && (multi_processor.can_collect()))){
                multi_processor.highlight_collect();
                return (_tip(collect_message));
            };
            var i:Number = 1;
            while (i <= multi_processor.num_raw_materials()) {
                if (((multi_processor.refill_over(i)) && (multi_processor.can_refill_with(i)))){
                    multi_processor.highlight_refill(i);
                    return (_tip(get_tip_message("refill", i)));
                };
                i++;
            };
            if (default_message()){
                return;
            };
            multi_processor.clear_highlight();
            _tip("");
        }
        protected function _tip(msg:String, obj:MapObject=null, color:Number=-1):void{
            if (is_working()){
                current_message = msg;
                start_timer();
                return;
            };
            tip(msg, obj, color);
        }
        protected function default_mouseUp():void{
            if (multi_processor.can_refill_with(1)){
                refill_material = 1;
                return (confirm(REFILL_MAP_OBJECT));
            };
        }
        protected function is_working():Boolean{
            return (((multi_processor) && ((multi_processor.next_product_in() > 0))));
        }
        override protected function mouseDown():void{
        }
        override protected function disable():void{
            stop_timer();
            super.disable();
        }
        override protected function mouseOut():void{
            if (multi_processor){
                multi_processor.clear_highlight();
            };
            hide_tip();
            stop_timer();
        }
        override protected function mouseUp():void{
            if (!multi_processor){
                return;
            };
            if (multi_processor.is_under_construction()){
                confirm(Map.SHOW_UNDER_CONSTRUCTION_POPUP);
                return;
            };
            if (multi_processor.switch_over()){
                return (confirm(SELECT_RAW_MATERIAL));
            };
            if (multi_processor.is_automatic()){
                return;
            };
            if (((multi_processor.collect_over()) && (multi_processor.can_collect()))){
                return (confirm(COLLECT_PRODUCT));
            };
            var i:Number = 1;
            while (i <= multi_processor.num_raw_materials()) {
                if (((multi_processor.refill_over(i)) && (multi_processor.can_refill_with(i)))){
                    refill_material = i;
                    return (confirm(REFILL_MAP_OBJECT));
                };
                i++;
            };
            default_mouseUp();
        }
        protected function start_timer():void{
            stop_timer();
            interval = setInterval(show_timer, 900);
            show_timer();
        }
        protected function get_tip_message(action:String, index:Number):String{
            if (!multi_processor){
                return (refill_message);
            };
            return (("Click to add " + multi_processor.get_raw_material_name(index)));
        }
        override public function get_event_data():Object{
            switch (action_name){
                case COLLECT_PRODUCT:
                    return (multi_processor);
                case REFILL_MAP_OBJECT:
                    return ({
                        obj:multi_processor,
                        material:refill_material,
                        raw_material:multi_processor.get_raw_material_id(refill_material)
                    });
                case SHOW_CONFIRM_ERROR:
                    return (error_message);
                case SELECT_RAW_MATERIAL:
                    return (multi_processor);
                default:
                    return (multi_processor);
            };
        }

    }
} 
