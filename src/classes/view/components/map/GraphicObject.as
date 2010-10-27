package classes.view.components.map {
    import flash.display.*;
	
	/**
	 * GreenHouse可能会用到
	 */ 
    public class GraphicObject extends MapObject {

        private var _graphic:MovieClip;
        private var _fake_x:Number;
        private var _fake_y:Number;
        private var use_fake_coords:Boolean = false;
        private var _fake_flip_x:Number;
        private var _fake_flip_y:Number;

        public function GraphicObject(m:MovieClip, s_x:Number, s_y:Number, name:String=""){
            _graphic = m;
            var data:Object = new Object();
            data.id = 0;
            data.size_x = s_x;
            data.size_y = s_y;
            data.type = "graphic";
            data.name = name;
            super(data);
            asset.addChild(_graphic);
        }
        
        override public function get sort_grid_y():Number{
            if (!use_fake_coords){
                return (super.sort_grid_y);
            };
            if (is_flipped()){
                return (_fake_flip_y);
            };
            return (_fake_y);
        }
        
        override public function get sort_grid_x():Number{
            if (!use_fake_coords){
                return (super.sort_grid_x);
            };
            if (is_flipped()){
                return (_fake_flip_x);
            };
            return (_fake_x);
        }
        
        public function refresh_graphic(m:MovieClip=null):void{
            if (!m){
                if (!_graphic){
                    return;
                }
                if (asset.contains(_graphic)){
                    return;
                }
            } else {
                if (((_graphic) && (asset.contains(_graphic)))){
                    asset.removeChild(_graphic);
                }
                _graphic = m;
            }
            asset.addChild(_graphic);
        }
        
        override protected function refresh_asset():void{
            asset_loaded = true;
            if (last_grid_size){
                asset.scaleX = (asset.scaleX * (grid_size / last_grid_size));
                asset.scaleY = Math.abs(asset.scaleX);
            };
            Log.add(((((("refresh_asset " + last_grid_size) + " - ") + grid_size) + " - ") + asset.scaleX));
        }
        
        public function set_sort_coords(x:Number, y:Number, flip_x:Number, flip_y:Number):void{
            _fake_x = x;
            _fake_y = y;
            _fake_flip_x = flip_x;
            _fake_flip_y = flip_y;
            use_fake_coords = true;
        }
        
        override protected function refresh_hit_area():void{
        }

    }
}
