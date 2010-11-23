package classes.view.components.map {
    import flash.events.*;

    public class Greenhouse extends MapObject {

        public static const SPLIT_OBJECT:String = "splitObject";

        private var top_obj:GraphicObject;
        private var right_obj:GraphicObject;
        private var bottom_obj:GraphicObject;
        private var _plants:Array;
        private var opened:Boolean = false;
        private var _growing_percent:Number;
        private var left_obj:GraphicObject;

        public function Greenhouse(data:Object){
            _plants = new Array();
            _growing_percent = data.growing_percent;
            super(data);
        }
        
        public function get plants():Array {
        	return this._plants;
        }
        
        /**
         * 获取要保存的数据 
         */ 
        public function get allMapsSaveObject():Array {
        	var result:Array = [];
        	for each(var mapObject:MapObject in _plants){
        		if(mapObject is Plant){
        			result.push(Plant(mapObject).saveData);
        		}
        	}
        	return result;
        }
        
        override public function get sort_grid_x():Number{
            if (under_construction){
                return grid_x;
            }
            return ((grid_x + size_x) - 1);
        }
        
        override protected function init_asset():void{
            var x_s:Number;
            var y_s:Number;
            super.init_asset();
            if (!under_construction){ 
                x_s = (is_flipped()) ? y_size : x_size;
                y_s = (is_flipped()) ? x_size : y_size;
                top_obj = new GraphicObject(mc.top_part, x_s, 1, "top");
                left_obj = new GraphicObject(mc.left_part, 1, (y_s - 2), "left");
                right_obj = new GraphicObject(mc.right_part, 1, (y_s - 2), "right");
                bottom_obj = new GraphicObject(mc.bottom_part, x_s, 1, "bottom");
                top_obj.grid_size = 15;
                left_obj.grid_size = 15;
                right_obj.grid_size = 15;
                bottom_obj.grid_size = 15;
                if (is_flipped()){
                    top_obj.flip();
                    left_obj.flip();
                    right_obj.flip();
                    bottom_obj.flip();
                }
                dispatchEvent(new Event(SPLIT_OBJECT));
                mc.bottom_part.front.front_cut.visible = false;
                mc.right_part.front.front_cut.visible = false;
            }
            //this.showConstructionComplete();
        }
        
        public function right_object():GraphicObject{
            return right_obj;
        }
        
        public function remove_plant(p:MapObject):void{
            var i:Number = 0;
            while (i < _plants.length) {
                if (p == _plants[i]){
                    _plants.splice(i, 1);
                    return;
                }
                i++;
            }
        }
        
        override public function get sort_grid_y():Number{
            if (under_construction){
                return grid_y;
            }
            return ((grid_y + size_y) - 1);
        }
        
        override public function get sort_y_size():Number{
            if (under_construction){
                return (size_y);
            }
            return 1;
        }
        
        public function bottom_object():GraphicObject{
            return bottom_obj;
        }
        
        override protected function init():void{
            super.init();
            loader.cache_swf = true;
        }
        
        public function toggle():void{
            if (!mc){
                return;
            }
            try {
	            mc.bottom_part.front.front_cut.visible = !(mc.bottom_part.front.front_cut.visible);
	            mc.bottom_part.front.front_full.visible = !(mc.bottom_part.front.front_full.visible);
	            mc.right_part.front.front_cut.visible = !(mc.right_part.front.front_cut.visible);
	            mc.right_part.front.front_full.visible = !(mc.right_part.front.front_full.visible);
	            opened = !(opened);
	            refresh_hit_area();
            }catch(error:Error){
            	trace("mc.bottom_part.front.front_cut.visible " + error.message);
            }
        }
        
        public function add_plant(p:MapObject):void{
            _plants.push(p);
        }
        
        override protected function refresh_hit_area():void{
            if (under_construction || !opened){
                return (super.refresh_hit_area());
            }
            hit_area.graphics.clear();
            hit_area.graphics.beginFill(0, 0);
            hit_area.graphics.moveTo(0, 0);
            hit_area.graphics.lineTo(get_x(size_x, 0), get_y(size_x, 0));
            hit_area.graphics.lineTo(get_x(size_x, size_y), get_y(size_x, size_y));
            hit_area.graphics.lineTo(get_x(0, size_y), get_y(0, size_y));
            hit_area.graphics.lineTo(0, 0);
            hit_area.graphics.lineTo(get_x(1, 1), get_y(1, 1));
            hit_area.graphics.lineTo(get_x((size_x - 1), 1), get_y((size_x - 1), 1));
            hit_area.graphics.lineTo(get_x((size_x - 1), (size_y - 1)), get_y((size_x - 1), (size_y - 1)));
            hit_area.graphics.lineTo(get_x(1, (size_y - 1)), get_y(1, (size_y - 1)));
            hit_area.graphics.lineTo(get_x(1, 1), get_y(1, 1));
            hit_area.graphics.endFill();
        }
        
        public function is_opened():Boolean{
            return opened;
        }
        
        override public function intersect(obj:MapObject, check_objects_type:Boolean=false):Boolean{
            if (!super.intersect(obj, check_objects_type)){
                return false;
            }
            if (!check_objects_type){
                return true;
            }
            if (under_construction){
                return true;
            }
            if (((!((obj as Plant))) && (!((obj.type == "soil"))))){
                return (true);
            };
            var x1:Number = grid_x;
            var x2:Number = obj.grid_x;
            var y1:Number = grid_y;
            var y2:Number = obj.grid_y;
            if (x2 <= x1){
                return (true);
            };
            if (y2 <= y1){
                return (true);
            }
            if ((x2 + obj.x_size) >= (x1 + x_size)){
                return true;
            }
            if ((y2 + obj.y_size) >= (y1 + y_size)){
                return true;
            }
            return false;
        }
        
        public function clear_plants():void{
            _plants = new Array();
        }
        
        public function join():void{
            if (!mc){
                return;
            }
            asset.addChild(mc.left_part);
            asset.addChild(mc.top_part);
            asset.addChild(mc.right_part);
            asset.addChild(mc.bottom_part);
        }
        
        override public function flip(animationable:Boolean = false):void{
            super.flip();
            if (!top_obj){
                return;
            }
            top_obj.flip();
            left_obj.flip();
            right_obj.flip();
            bottom_obj.flip();
        }
        
        public function top_object():GraphicObject{
            return top_obj;
        }
        
        public function get_plants():Array{
            return _plants;
        }
        
        public function has_plants():Boolean{
            return _plants.length > 0;
        }
        
        public function get growing_percent():Number{
            return _growing_percent;
        }
        
        public function left_object():GraphicObject{
            return left_obj;
        }
        
        override public function get sort_x_size():Number{
            if (under_construction){
                return size_x;
            }
            return 1;
        }
        
        override public function get saveObject():Object {
        	var result:Object = super.saveObject;
        	result.obtained_materials = this.obtained_materials;
        	return result;
        }
    }
}
