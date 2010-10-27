package classes.view.components.map.tools.shop_item_tools {
    import classes.utils.*;
    import classes.view.components.*;
    import classes.view.components.map.*;
    import classes.view.components.map.tools.*;
    
    import flash.display.*;
    
    import mx.resources.ResourceManager;

    public class InstallIrrigationTool extends Tool {

        private var add_on_obj:MapObject;
        protected var _tip:Confirmation;

        public function InstallIrrigationTool(data:Object){
            super(data);
            action_name = Map.INSTALL_IRRIGATION;
            show_cursor();
        }
        
        override protected function mouseUp():void{
            if (can_install()){
                if (_tip){
                    _tip.start();
                    _tip = null;
                };
                add_on_obj = target;
                confirm();
            };
        }
        
        private function show_cursor():void{
            Cursor.show(data.cursor, true, 5, 5);
        }
        
        override protected function mouseOut():void{
            hide_tip();
            if (can_install()){
                target.state = "clear";
            }
        }
        
        private function can_install():Boolean{
            if (!target){
                return (false);
            };
            if (((!((target.type == "seeds"))) && (!((target.type == "soil"))))){
                return (false);
            }
            if (target.has_irrigation()){
                return (false);
            }
            return (true);
        }
        
        override public function init(tool_cont:Sprite, map_objects:Sprite):void{
            super.init(tool_cont, map_objects);
            var obj:Object = new Object();
            obj.minus = ResourceManager.getInstance().getString("message","click_plowed_install_irrigation_message");
            obj.target = {
                x:0,
                y:0
            };
            obj.duration = 1;
            _tip = new Confirmation(obj);
            tool_cont.addChild(_tip);
        }
        
        override public function action_confirmed(... _args):void{
            add_on_obj.install_irrigation(_args[0].water_pipe);
            add_on_obj.state = "clear";
            if (_args[0].disable == true){
                disable();
            }
        }
        
        override protected function mouseOver():void{
            if (can_install()){
                target.state = "collect_over";
                tip(ResourceManager.getInstance().getString("message","click_to_install_sprinkler_message"));
            } else {
                if (((target) && (target.has_irrigation()))){
                    tip(ResourceManager.getInstance().getString("message","sprinkler_already_installed_message"));
                }
            }
        }
        
        override protected function mouseMove():void{
            show_cursor();
            if (_tip){
                _tip.x = ((tool_cont.mouseX - (_tip.width / 2)) + 20);
                _tip.y = ((tool_cont.mouseY + _tip.height) + 30);
                if (!tool_cont.contains(_tip)){
                    tool_cont.addChild(_tip);
                };
            };
        }
        override public function get_event_data():Object{
            return ({
                target:add_on_obj,
                water_pipe:data.id
            });
        }

    }
}
