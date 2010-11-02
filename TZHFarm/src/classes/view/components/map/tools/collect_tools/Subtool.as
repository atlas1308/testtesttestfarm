package classes.view.components.map.tools.collect_tools {
    import classes.view.components.map.*;
    import classes.view.components.map.tools.*;

    public class Subtool extends Tool {

        protected const SELECT_RAW_MATERIAL:String = "selectRawMaterial";
        protected const FEED_MAP_OBJECT:String = "feedMapObject";
        protected const COLLECT_PRODUCT:String = "collectProduct";
        protected const REFILL_MAP_OBJECT:String = "refillMapObject";

        public function Subtool(){
            super();
            disable();
            TYPE = "subtool";
        }
        
        public function usable():Boolean{
            return true;
        }
        
        public function allow():Boolean{
            if (!target){
                return (false);
            }
            return ((target as MapObject));
        }

    }
}
