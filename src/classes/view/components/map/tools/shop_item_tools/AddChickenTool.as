package classes.view.components.map.tools.shop_item_tools {
    import classes.utils.*;
    import classes.view.components.map.*;
    import classes.view.components.map.tools.*;
    
    import mx.resources.ResourceManager;

    public class AddChickenTool extends Tool {

        private const ADD_ANIMAL:String = "addAnimal";

        private var add_on_obj:ChickenCoop;

        public function AddChickenTool(data:Object){
            super(data);
            action_name = ADD_ANIMAL;
            show_cursor();
        }
        
        override protected function mouseUp():void{
            if ((target as ChickenCoop)){
                add_on_obj = (target as ChickenCoop);
                confirm();
            }
        }
        
        override public function action_confirmed(... _args):void{
            add_on_obj.addAnimal();
            if (((_args.length) && ((_args[0] == true)))){
                disable();
            };
        }
        
        override public function get_event_data():Object{
            return (add_on_obj);
        }
        
        override protected function mouseOver():void{
            if ((target as ChickenCoop)){
                target.state = "collect_over";
                tip(ResourceManager.getInstance().getString("message","click_to_add_chicken_message"));
            }
        }
        override protected function mouseOut():void{
            hide_tip();
            if ((target as ChickenCoop)){
                target.state = "clear";
            }
        }
        
        override protected function mouseMove():void{
            show_cursor();
        }
        private function show_cursor():void{
            Cursor.show(data.image, true, 5, 5);
        }

    }
}
