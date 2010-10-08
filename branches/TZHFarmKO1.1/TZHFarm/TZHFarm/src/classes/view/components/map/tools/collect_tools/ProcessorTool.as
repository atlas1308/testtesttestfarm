
package classes.view.components.map.tools.collect_tools {
    import classes.view.components.map.*;
    
    import flash.utils.*;
    
    import mx.resources.ResourceManager;

    public class ProcessorTool extends Subtool {

        public static var id:Number = 0;

        protected var no_ready_food_message:String = "";
        protected var feeding:Boolean = false;
        protected var feed_message_after_click:String = "";
        protected var time_message:String = "Next milk in";
        protected var obj_to_feed:Processor;
        protected var food_message:String = "";
        protected var _id:Number;
        protected var wait_message:String = "Wait";
        protected var current_message:String;
        protected var interval:Number;
        protected var obj_to_eat:CollectObject;
        protected var feed_message:String = "";
        protected var no_food_message:String = "";
        protected var collect_message:String = "Click to collect!";

        public function ProcessorTool(){
            super();
            _id = ProcessorTool.id++;
        }
        protected function show_timer():void{
            if (!is_working()){
                stop_timer();
                mouseOver();
                return;
            };
            var msg:String = current_message;
            if (msg != ""){
                msg = (msg + "\n");
            };
            msg = (msg + (((eater.product_name() + ": ") + eater.product_percent()) + "% Ready"));
            tip(msg);
        }
        protected function get eater():Processor{
            return ((target as Processor));
        }
        override public function remove():void{
            stop_timer();
        }
        protected function can_refill():Boolean{
            if (!eater){
                return (false);
            };
            return (eater.can_feed());
        }
        override public function action_confirmed(... _args):void{
            switch (action_name){
                case FEED_MAP_OBJECT:
                    obj_to_feed.feed();
                    break;
                case COLLECT_PRODUCT:
                    eater.collect();
                    mouseOver();
                    break;
            };
        }
        override protected function mouseOver():void{
            if (eater){
                if (eater.is_automatic()){
                    eater.highlight_automation_areas(12827065);
                    return _tip(ResourceManager.getInstance().getString("message","automation_on_message"));
                }
                if (wait()){
                    return (_tip(wait_message));
                }
                if (can_collect()){
                    eater.highlight_collect();
                    return (_tip(collect_message));
                };
                if (can_refill()){
                    eater.highlight_refill();
                    return (_tip(get_feed_message()));
                }
            }
            if (eater){
                eater.clear_highlight();
            };
            _tip("");
        }
        
        protected function no_food():Boolean{
            var obj:CollectObject;
            if (!eater){
                return (false);
            };
            var i:Number = 0;
            while (i < map_objects.numChildren) {
                obj = (map_objects.getChildAt(i) as CollectObject);
                if (!obj){
                } else {
                    if (obj.id == eater.raw_material_id){
                        return (false);
                    };
                };
                i++;
            };
            return (true);
        }
        
        override protected function mouseMove():void{
            mouseOver();
        }
        
        override protected function mouseUp():void{
            if (eater){
                if (eater.is_automatic()){
                    return;
                };
                if (can_collect()){
                    action_name = COLLECT_PRODUCT;
                    confirm();
                } else {
                    if (can_refill()){
                        action_name = FEED_MAP_OBJECT;
                        obj_to_feed = eater;
                        confirm();
                    } else {
                        action_name = SHOW_CONFIRM_ERROR;
                        confirm(ResourceManager.getInstance().getString("message","error_message_full_message",[eater.get_name()]));
                    }
                }
            }
        }
        
        protected function is_working():Boolean{
            return (((eater) && ((eater.next_product_in() > 0))));
        }
        protected function start_timer():void{
            stop_timer();
            interval = setInterval(show_timer, 900);
            show_timer();
        }
        protected function get_feed_message():String{
            if (eater){
                if (eater.type == "animals"){
                    return ResourceManager.getInstance().getString("message","click_to_feed_message",[eater.raw_material_name()]);
                }
                return ResourceManager.getInstance().getString("message","click_to_add_message",[eater.raw_material_name()]);
            }
            return ("");
        }
        
        protected function no_ready_food(_eater:Processor=null):Boolean{
            var obj:CollectObject;
            _eater = (_eater) ? _eater : eater;
            if (!_eater){
                return (false);
            };
            var i:Number = 0;
            while (i < map_objects.numChildren) {
                obj = (map_objects.getChildAt(i) as CollectObject);
                if (!obj){
                } else {
                    if ((((obj.id == _eater.raw_material_id)) && (obj.is_ready()))){
                        return (false);
                    };
                };
                i++;
            };
            return (true);
        }
        protected function can_collect(_obj:Processor=null):Boolean{
            var c:Processor = (_obj) ? _obj : eater;
            if (((c.collect_over()) && (c.can_collect()))){
                return (true);
            };
            return (false);
        }
        override public function get_event_data():Object{
            switch (action_name){
                case COLLECT_PRODUCT:
                    return (eater);
                case FEED_MAP_OBJECT:
                    return (eater);
                case SHOW_CONFIRM_ERROR:
                    return (error_message);
                default:
                    return ({});
            };
        }
        override public function allow():Boolean{
            if (eater){
                return (false);
            };
            if (super.allow()){
                hide_tip();
            };
            return (super.allow());
        }
        protected function stop_timer():void{
            clearInterval(interval);
        }
        protected function get food():CollectObject{
            var o:Processor;
            if ((target as CollectObject)){
                o = (obj_to_feed) ? obj_to_feed : eater;
                if (!o){
                    return (null);
                };
                if ((((target.id == o.raw_material_id)) && (CollectObject(target).is_ready()))){
                    return ((target as CollectObject));
                };
            };
            return (null);
        }
        protected function _tip(msg:String, obj:MapObject=null, color:Number=-1):void{
            if (is_working()){
                current_message = msg;
                start_timer();
                return;
            };
            tip(msg, obj, color);
        }
        override protected function mouseDown():void{
            if (eater){
                //Log.add(((((((((eater + " id:") + eater.map_unique_id) + " products:") + eater.get_products()) + " raw_materials:") + eater.get_raw_materials()) + " next stage: ") + eater.next_stage_in()));
            }
        }
        override protected function disable():void{
            stop_timer();
            super.disable();
        }
        override protected function mouseOut():void{
            if (eater){
                eater.clear_highlight();
            };
            hide_tip();
            stop_timer();
        }
        protected function wait():Boolean{
            if (!eater){
                return (false);
            };
            if (((!(eater.can_feed())) && (!(eater.can_collect())))){
                return (true);
            };
            return (false);
        }

    }
} 
