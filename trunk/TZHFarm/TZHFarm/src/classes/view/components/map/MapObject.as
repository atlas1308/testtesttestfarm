package classes.view.components.map {
    import classes.utils.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;

    public class MapObject extends Sprite {

        public static var unique_id:Number = 0;

        public const ON_CHANGE:String = "onChange";
        public const PROCESS_FINISH:String = "processFinish";

        public var map_flip_state:Number = 0;
        protected var _enabled:Boolean = true;
        protected var _type:String;
        protected var loader:Cache;
        protected var water_pipe_id:Number;
        public var map_unique_id:Number;
        protected var state_cont:Sprite;
        protected var materials:Array;
        protected var asset_loaded:Boolean = false;
        protected var process_count:Object;
        public var map_x:Number = 0;
        public var map_y:Number = 0;
        protected var _is_tall:Boolean;
        protected var _name:String;
        protected var x_coord:Array;
        protected var _kind:String;
        protected var corner_bl:highlight_corner1;
        protected var rotate_btn:MovieClip;
        protected var corner_br:highlight_corner2;
        protected var upgradeable:Boolean;
        protected var complete_size_x:Number = 0;
        protected var complete_size_y:Number = 0;
        protected var flipped:Number = 0;
        protected var water_pipe_url:String;
        protected var under_construction_url:String;
        protected var water_pipe_growing_percent:Number;
        protected var _state:String;
        protected var water_pipe_loader:Cache;
        protected var asset_url:String;
        protected var upgrade_level:Number;
        protected var corner_tl:highlight_corner2;
        protected var _greenhouse:Greenhouse;
        protected var _flipable:Boolean;
        protected var corner_tr:highlight_corner1;
        protected var y_coord:Array;
        protected var obtained_materials:Object;
        protected var hit_area:Sprite;
        protected var _id:Number;
        protected var size_y:Number;
        protected var view_angle:Number = 1.09083078249646;
        protected var size_x:Number;
        protected var water_pipe:Bitmap;
        protected var under_construction:Boolean = false;
        protected var _grid_size:Number;
        protected var waiting_to_process:Boolean = false;
        protected var _grid_x:Number;// 格子的X轴坐标
        protected var _grid_y:Number;// 格子的Y轴坐标
        protected var flipped_from_store:Boolean = false;
        protected var asset:Sprite;
        protected var last_grid_size:Number;
        protected var upgrade_levels:Object;
        protected var map_size_x:Number;
        protected var map_size_y:Number;
        
        public static const MAP_OBJECT_TYPE_SEEDS:String = "seeds";// 种植物
        public static const MAP_OBJECT_TYPE_ANIMALS:String = "animals";// 动物
        public static const MAP_OBJECT_TYPE_GEAR:String = "gear";
        public static const MAP_OBJECT_TYPE_BUILDINGS:String = "buildings";// 建筑物
        public static const MAP_OBJECT_TYPE_SPECIAL_EVENTS:String = "special_events";// 特殊事件
        public static const MAP_OBJECT_TYPE_TREES:String = "trees";// 树
        public static const MAP_OBJECT_TYPE_DECORATIONS:String = "decorations";// 装饰
		
		public static const MAP_OBJECT_TYPE_SOLI:String = "soil";
		private var _data:Object;
		
		public function get data():Object {
			return this._data;
		}
		
        public function MapObject(data:Object){
            x_coord = new Array();
            y_coord = new Array();
            process_count = {};
            super();
            this._data = data;
            map_unique_id = MapObject.unique_id++;
            name = ("obj_" + map_unique_id);
            _id = data.id;
            _name = data.name;
            _type = data.type;
            size_x = data.size_x;
            size_y = data.size_y;
            _kind = (data.kind) ? data.kind : "";
            map_flip_state = (flipped = (data.flipped) ? 1 : 0);
            flipped_from_store = (data.flipped_from_store) ? true : false;
            obtained_materials = (data.obtained_materials) ? data.obtained_materials : new Object();
            materials = (data.materials) ? data.materials : new Array();// 原料
            upgrade_levels = (data.upgrade_levels) ? data.upgrade_levels : new Object();
            under_construction = PHPUtil.toBoolean(data.under_construction);
            _is_tall = (data.tall_object) ? true : false;
            water_pipe_url = (data.water_pipe_url) ? data.water_pipe_url : "";
            water_pipe_id = (data.water_pipe) ? data.water_pipe : 0;
            water_pipe_growing_percent = (data.water_pipe_growing_percent) ? data.water_pipe_growing_percent : 0;
            upgrade_level = (data.upgrade_level) ? data.upgrade_level : 1;
            upgradeable = (data.upgradeable) ? true : false;
            complete_size_y = (data.complete_size_y) ? data.complete_size_y : 0;
            complete_size_x = (data.complete_size_x) ? data.complete_size_x : 0;
            if (((!((data.x === null))) && (!((data.y === null))))){
                grid_x = (map_x = data.x);
                grid_y = (map_y = data.y);
            };
            _flipable = (data.flipable) ? true : false;
            asset_url = data.swf;
            under_construction_url = (data.swf_uc) ? data.swf_uc : "";
            init();
        }
        
        protected function init_asset():void{
        }
        
        public function focus():void{
            var arr:arrow = new arrow();
            arr.x = ((_width - arr.width) / 2);
            arr.y = ((_height / 2) - arr.height);
            addChild(arr);
        } 
        
        public function get y_size():Number{
            return (size_y);
        }
        
        public function changed():void{
            dispatchEvent(new Event(ON_CHANGE));
        }
        
        protected function queue_highlight():void{
            state_cont.visible = false;
            alpha = 0.5;
        }
        
        public function get left():Number{
            return ((grid_x * _grid_size));
        }
        
        public function end_process(value:String):void{
            var _local2:Object = process_count;
            var key:* = value;
            var _local4:int = (_local2[key] - 1);
            _local2[key] = _local4;
            waiting_to_process = false;
            state = "clear";
        }
        
        public function is_under_construction():Boolean{
            return under_construction;
        }
        
        protected function assetLoaded(e:Event):void{
            asset_loaded = true;
            asset.scaleY = (grid_size / 15);
            if (asset.scaleX < 0){
                asset.scaleX = -(asset.scaleY);
            } else {
                asset.scaleX = asset.scaleY;
            }
            clear_asset();
            add_asset();
            init_asset();
            if (water_pipe){
                asset.addChild(water_pipe);
            }
        }
        
        public function get id():Number{
            return _id;
        }
        
        public function get right():Number{
            return (((grid_x + size_x) * _grid_size));
        }
        
        public function is_flipped_from_store():Boolean{
            return flipped_from_store;
        }
        
        protected function init():void{
            loader = new Cache();
            water_pipe_loader = new Cache();
            hit_area = new Sprite();
            addChild(hit_area);
            asset = new Sprite();
            addChild(asset);
            state_cont = new Sprite();
            addChild(state_cont);
            corner_br = new highlight_corner2();
            corner_bl = new highlight_corner1();
            corner_tl = new highlight_corner2();
            corner_tr = new highlight_corner1();
            corner_tr.rotation = 180;
            corner_tl.rotation = 180;
            state_cont.addChild(corner_br);
            state_cont.addChild(corner_bl);
            state_cont.addChild(corner_tr);
            state_cont.addChild(corner_tl);
            rotate_btn = new RotateBtn();
            addChild(rotate_btn);
            rotate_btn.visible = false;
            mouseEnabled = false;
            asset.mouseEnabled = false;
            asset.mouseChildren = false;
            state_cont.mouseEnabled = false;
            state_cont.mouseChildren = false;
            state_cont.visible = false;
            loader.addEventListener(Cache.LOAD_COMPLETE, assetLoaded);
            if (water_pipe_id){
                water_pipe_loader.addEventListener(Cache.LOAD_COMPLETE, water_pipe_loaded);
                water_pipe_loader.load(water_pipe_url);
            }
            if (((!((type == "seeds"))) && (!((type == "soil"))))){
                setChildIndex(state_cont, 0);
            }
            if (flipped){
                flip();
            }
        }
        
        public function set state(s:String):void{
            if (((waiting_to_process) && (((((!((s == "remove_over"))) && (!((s == "clear"))))) && (!((s == "waiting_to_process"))))))){
                return;
            }
            switch (s){
                case "intersect_whitout_corners":
                    highlight(0xCC0033, 0.45, false);
                    break;
                case "intersect":
                    highlight(0xCC0033, 0.45, true, 0, true);
                    break;
                case "move_over":
                    highlight(0x9900, 0.2, true, -1, true);
                    break;
                case "remove_over":
                    highlight(0xCC0033, 0.45, true, -1);
                    break;
                case "collect_over":
                    if ((type == "seeds") || (type == "soil") || (kind == "fertilizer")){
                        Effects.glow(asset);
                    }
                    break;
                case "fertilize":
                    highlight(9523999, 0.45, true, -1);
                    break;
                case "fertilized":
                    highlight(9523999, 0.15);
                    break;
                case "on_move":
                    highlight(0x9900, 0.69, true, 0, true);
                    break;
                case "on_add":
                    highlight(0x9900, 0.69);
                    break;
                case "on_plant":
                    highlight(0x9900, 0.69);
                    break;
                case "processing":
                    highlight(0x9900, 0.69, false);
                    break;
                case "waiting_to_process":
                    queue_highlight();
                    break;
                case "clear":
                    if (!waiting_to_process){
                        state_cont.graphics.clear();
                        asset.filters = [];
                        state_cont.visible = false;
                        if (rotate_btn){
                            rotate_btn.visible = false;
                        };
                        alpha = 1;
                    } else {
                        state = "waiting_to_process";
                    };
                    break;
            }
            _state = s;
        }
        
        public function greenhouse_removed():void{
            _greenhouse = null;
        }
        
        public function get sort_x_size():Number{
            return (size_x);
        }
        
        public function get greenhouse():Greenhouse{
            return _greenhouse;
        }
        
        public function intersect(obj:MapObject, check_objects_type:Boolean=false):Boolean{
            var x1:Number;
            var x2:Number;
            var y1:Number;
            var y2:Number;
            var _local7:Number;
            if ((((this as GraphicObject)) || ((obj as GraphicObject)))){
                return (false);
            };
            if (!check_objects_type){
                if ((((bottom <= obj.top)) || ((obj.bottom <= top)))){
                    return (false);
                };
                if ((((right <= obj.left)) || ((obj.right <= left)))){
                    return (false);
                };
                return (true);
            };
            if ((((((obj as Greenhouse)) && (!(obj.is_under_construction())))) && ((((type == "seeds")) || ((type == "soil")))))){
                if (intersect(obj, false)){
                    x1 = obj.grid_x;
                    x2 = grid_x;
                    y1 = obj.grid_y;
                    y2 = grid_y;
                    if (x2 <= x1){
                        return (true);
                    };
                    if (y2 <= y1){
                        return (true);
                    };
                    if ((x2 + x_size) >= (x1 + obj.x_size)){
                        return (true);
                    };
                    if ((y2 + y_size) >= (y1 + obj.y_size)){
                        return (true);
                    };
                    return (false);
                };
            };
            if (obj.type == type){
                switch (type){
                    case "trees":
                        _local7 = (Math.max(Tree(this).spacing, Tree(obj).spacing) * grid_size);
                        if (((((bottom + _local7) <= obj.top)) || ((obj.bottom <= (top - _local7))))){
                            return (false);
                        };
                        if (((((right + _local7) <= obj.left)) || ((obj.right <= (left - _local7))))){
                            return (false);
                        };
                        return (true);
                    case "decorations":
                        if ((((kind == "fence")) && ((obj.kind == "fence")))){
                            if (intersect(obj)){
                                if (((((((obj.is_flipped() != is_flipped()))) && ((((bottom == obj.bottom)) || ((top == obj.top)))))) && ((((left == obj.left)) || ((right == obj.right)))))){
                                    return false;
                                }
                                // fence不能重叠,这个和原游戏不相同
                                if((obj.is_flipped() == is_flipped()) && (left == obj.left) ) {
                                	if((bottom == (obj.top + grid_size)) || (obj.bottom == (top + grid_size))){// 修改了这句判断,顶部可以重,底也可以重
                                		return false;
                                	}else {
                                		return true;
                                	}
                                }
                                /* if ((((obj.is_flipped() == is_flipped())) && ((((left == obj.left)) && ((((bottom == (obj.top + grid_size))) || ((obj.bottom == (top + grid_size))))))))){
                                    //return false;
                                    return true;
                                } */
                                if ((((obj.is_flipped() == is_flipped())) && ((((top == obj.top)) && ((((right == (obj.left + grid_size))) || ((obj.right == (left + grid_size))))))))){
                                    return false;
                                }
                                return true;
                            }
                            return (false);
                        }
                        return (intersect(obj));
                    default:
                        return (intersect(obj));
                };
            };
            return (intersect(obj));
        }
        
        protected function refresh_coords():void{
            x = get_x(_grid_x, _grid_y);
            y = get_y(_grid_x, _grid_y);
        }
        
        public function get is_fence():Boolean{
            return ((_kind == "fence"));
        }
        
        public function install_irrigation(obj:Object):void{
            water_pipe_url = obj.image;
            water_pipe_id = obj.id;
            water_pipe_growing_percent = obj.growing_percent;
            water_pipe_loader.addEventListener(Cache.LOAD_COMPLETE, water_pipe_loaded);
            water_pipe_loader.load(water_pipe_url);
        }
        
        public function get bottom():Number{
            return (((grid_y + size_y) * _grid_size));
        }
        
        public function greenhouse_added(g:Greenhouse):void{
            _greenhouse = g;
        }
        
        public function get type():String{
            return _type;
        }
        
        public function increase_obtained_material(material:Number):void{
            if (!obtained_materials[material]){
                obtained_materials[material] = 0;
            }
            var _local2 = obtained_materials;
            var _local3 = material;
            var _local4 = (_local2[_local3] + 1);
            _local2[_local3] = _local4;
            this.showConstructionComplete();
        }
        
        public function showConstructionComplete():void {
        	if (numObtainedMaterials() == numMaterials()){
                if (!can_upgrade()){
                    under_construction = false;
                    if (complete_size_x){
                        size_x = complete_size_x;
                    }
                    if (complete_size_y){
                        size_y = complete_size_y;
                    }
                    refresh_hit_area();
                    construction_complete();
                } else {
                    upgrade_level++;
                    on_upgrade();
                }
                obtained_materials = new Array();
            }
        }
        
        public function get _height():Number{
            return ((((size_x + size_y) * _grid_size) * Math.sin(view_angle)));
        }
        
        public function get scale():Number{
            return asset.scaleY;
        }
        
        /**
         * 获取原材料需要的总的数量 
         */ 
        public function numMaterials():Number{
            var result:Number = 0;
            var list:Array = (can_upgrade()) ? upgrade_levels[(upgrade_level + 1)] : materials;
            var index:Number = 0;
            while (list && index < list.length) {
                result = result + list[index].qty;
                index++;
            }
            return result;
        }
        
        public function get flipable():Boolean{
            return (_flipable);
        }
        public function get enabled():Boolean{
            return (_enabled);
        }
        public function get top():Number{
            return ((grid_y * _grid_size));
        }
        public function get_water_pipe():Number{
            return (water_pipe_id);
        }
        public function rotate_btn_clicked():Boolean{
            var p:Point = localToGlobal(new Point(mouseX, mouseY));
            return (rotate_btn.hitTestPoint(p.x, p.y, true));
        }
        public function get grid_size():Number{
            return _grid_size;
        }
        
        public function kill():void{
            loader.removeEventListener(Cache.LOAD_COMPLETE, assetLoaded);
            clear_asset();
            if(parent){
            	parent.removeChild(this);
            }
        }
        
        public function simple_object():Object{
            var obj:Object = new Object();
            obj.sort_grid_x = (_grid_size) ? sort_grid_x : map_x;
            obj.sort_grid_y = (_grid_size) ? sort_grid_y : map_y;
            obj.sort_x_size = sort_x_size;
            obj.sort_y_size = sort_y_size;
            obj.is_fence = (_kind == "fence");
            obj.mo = this;
            return (obj);
        }
        
        public function flip():void{
            asset.scaleX = (asset.scaleX * -1);
            var old_size_x:Number = size_x;
            size_x = size_y;
            size_y = old_size_x;
            refresh_hit_area();
            rotate_btn.scaleX = (rotate_btn.scaleX * -1);
            dispatchEvent(new Event(ON_CHANGE));
        }
        public function get x_size():Number{
            return (size_x);
        }
        
        public function get stage_x():Number{
            return localToGlobal(new Point(0, 0)).x;
        }
        
        public function is_flipped():Boolean{
            return ((asset.scaleX < 0));
        }
        public function get stage_y():Number{
            return (localToGlobal(new Point(0, 0)).y);
        }
        public function clear_process(channel:String):void{
        }
        
        protected function get bmp():Bitmap{
            if (asset.numChildren){
                return asset.getChildAt(0) as Bitmap;
            }
            return null;
        }
        
        public function get sort_grid_x():Number{
            return grid_x;
        }
        
        public function set enabled(v:Boolean):void{
            _enabled = v;
        }
        
        protected function clear_asset():void{
            while (asset.numChildren) {
                asset.removeChildAt(0);
            }
        }
        
        protected function water_pipe_loaded(e:Event):void{
            water_pipe = (e.target.asset as Bitmap);
            asset.addChild(water_pipe);
            water_pipe.x = (Algo.get_x(size_x, (size_y / 2), view_angle, 15) - (water_pipe.width / 2));
            water_pipe.y = (Algo.get_y(size_x, (size_y / 2), view_angle, 15) - water_pipe.height);
        }
        
        public function set grid_y(v:Number):void{
            _grid_y = v;
            refresh_coords();
        }
        
        public function get sort_grid_y():Number{
            return grid_y;
        }
        
        public function process():void{
            waiting_to_process = true;
            state = "waiting_to_process";
        }
        protected function refresh_asset():void{
            if (last_grid_size){
                asset.scaleX = (asset.scaleX * (grid_size / last_grid_size));
                asset.scaleY = Math.abs(asset.scaleX);
            }
            if (((!(asset.numChildren)) || (((water_pipe) && ((asset.numChildren == 1)))))){
                if (under_construction){
                    loader.load(under_construction_url);
                } else {
                	if(!asset_url)return;
                    loader.load(asset_url);
                }
            }
        }
        
        public function get kind():String{
            return _kind;
        }
        public function get_upgrade_level():Number{
            return (upgrade_level);
        }
        
        protected function refresh_hit_area():void{
            hit_area.graphics.clear();
            hit_area.graphics.beginFill(0, 0);
            hit_area.graphics.moveTo(0, 0);
            hit_area.graphics.lineTo(get_x(size_x, 0), get_y(size_x, 0));
            hit_area.graphics.lineTo(get_x(size_x, size_y), get_y(size_x, size_y));
            hit_area.graphics.lineTo(get_x(0, size_y), get_y(0, size_y));
            hit_area.graphics.lineTo(0, 0);
            hit_area.graphics.endFill();
        }
        
        public function preload_position(channel:String):Object{
            var x:Number = stage_x;
            var y:Number = (stage_y - 20);
            return ({
                x:x,
                y:y
            });
        }
        
        protected function get mc():MovieClip{
            if (asset.numChildren){
                return ((asset.getChildAt(0) as MovieClip));
            }
            return null;
        }
        
        public function is_tall():Boolean{
            return _is_tall;
        }
        
        public function set grid_x(v:Number):void{
            _grid_x = v;
            refresh_coords();
        }
        
        protected function zoomable():Boolean{
            return false;
        }
        
        protected function highlight(color:Number=0xFF0000, alpha:Number=0.2, show_corners:Boolean=true, padd:Number=5, show_rotate_btn:Boolean=false):void{
            state_cont.graphics.clear();
            state_cont.graphics.lineStyle(1, 0, 0, true);
            state_cont.graphics.beginFill(color, alpha);
            state_cont.graphics.moveTo(0, 0);
            state_cont.graphics.lineTo(get_x(size_x, 0), get_y(size_x, 0));
            state_cont.graphics.lineTo(get_x(size_x, size_y), get_y(size_x, size_y));
            state_cont.graphics.lineTo(get_x(0, size_y), get_y(0, size_y));
            state_cont.graphics.lineTo(0, 0);
            state_cont.graphics.endFill();
            state_cont.visible = true;
            corner_tr.x = 0;
            corner_tr.y = 0;
            corner_bl.x = get_x(size_x, 0);
            corner_bl.y = get_y(size_x, 0);
            corner_tr.x = get_x(0, size_y);
            corner_tr.y = get_y(0, size_y);
            corner_br.x = get_x(size_x, size_y);
            corner_br.y = get_y(size_x, size_y);
            corner_tl.visible = (corner_br.visible = (corner_bl.visible = (corner_tr.visible = show_corners)));
            if (flipable){
                rotate_btn.x = corner_br.x;
                if (_height > 100){
                    rotate_btn.y = (corner_br.y - rotate_btn.height);
                } else {
                    rotate_btn.y = (corner_br.y - (rotate_btn.height / 2));
                };
                rotate_btn.visible = show_rotate_btn;
            } else {
                rotate_btn.visible = false;
            }
        }
        
        public function wait_to_process(value:String):void{
            if (process_count[value] == undefined){
                process_count[value] = 0;
            }
            var obj:Object = process_count;
            var channel:String = value;
            var temp:int = int(obj[channel]) + 1;
            obj[channel] = temp;
            state = "waiting_to_process";
            waiting_to_process = true;
        }
        
        public function remove_irrigation():void{
            water_pipe_id = 0;
            if (asset.contains(water_pipe)){
                asset.removeChild(water_pipe);
            }
            water_pipe = null;
        }
        
        public function get grid_x():Number{
            return get_grid_x(x, y);
        }
        
        public function toggle_alpha(alpha_mode:Boolean):void{
            if (is_tall()){
                if (alpha_mode){
                    asset.alpha = 0.25;
                } else {
                    asset.alpha = 1;
                }
            }
        }
        
        protected function on_upgrade():void{
        }
        
        public function numObtainedMaterials():Number{
            var key:String;
            var result:Number = 0;
            for (key in obtained_materials) {
                result = (result + obtained_materials[key]);
            }
            return result;
        }
        
        public function hit_test(x:Number, y:Number):Boolean{
            var p:Point = parent.localToGlobal(new Point(x, y));
            return (hit_area.hitTestPoint(p.x, p.y, true));
        }
        
        /* private var _highlightBitmapData:BitmapData;
		protected function getHighlight():void{
            var bitmap:* = null;
            if (_highlightBitmapData != null){
                _highlightBitmapData.dispose();
                _highlightBitmapData = null;
            }
            try {
                bitmap = asset.getChildAt(0);
                if (bitmap != null && bitmap is Bitmap && bitmap.width > 0){
                    _highlightBitmapData = (bitmap as Bitmap).bitmapData;
                } 
            } catch(err:Error) {
            	trace("get bitmap hitTest error");
            }
        } */
        
        /**
         * flashplayer 9的最大限制 
         */ 
        /* public function get highlightBitmapData():BitmapData {
        	if(!_highlightBitmapData){
        		_highlightBitmapData = new BitmapData(Math.min(asset.width,2880),Math.min(asset.height,2880),true,0x00000000);
        		_highlightBitmapData.draw(asset);
        	}
        	return _highlightBitmapData;
        } */
        
        /**
         * 这个方法还是得重写,现在特别是3维的方式渲染的话,还是有些问题
         * hisTest的方法总是不正确呢
         */ 
        public function hit_test_object(value:DisplayObject):Boolean {
        	var result:Boolean; 
        	if(this.asset){
        		result = this.asset.hitTestObject(value);
        	}
        	return result;
        }
        
        public function get grid_y():Number{
            return (get_grid_y(x, y));
        }
        
        protected function get_grid_x(x:Number, y:Number):Number{
            var key:String = "coord_" + x + "_" + y + "_" + _grid_size;
            if (!x_coord[key]){
                x_coord[key] = Algo.get_grid_x(x, y, view_angle, _grid_size);
            }
            return (Number(x_coord[key]));
        }
        
        public function get depth():Number{
            var start:Point = new Point(sort_grid_x, sort_grid_y);
            var end:Point = new Point((sort_grid_x + sort_x_size), (sort_grid_y + sort_y_size));
            var ww:Number = ((start.x + end.x) / 2);
            var m_depthIndex:Number = (((ww + ((start.y + end.y) / 2)) * 1000) + ww);
            return (m_depthIndex);
        }
        
        public function snapToGrid(x_s:Number, y_s:Number, top_s:Number):void{
            var limit:Number;
            map_size_x = x_s;
            map_size_y = y_s;
            var _x:Number = (get_grid_x(parent.mouseX, parent.mouseY) - int((size_x / 2)));
            var _y:Number = (get_grid_y(parent.mouseX, parent.mouseY) - int((size_y / 2)));
            if ((((type == "seeds")) || ((type == "soil")))){
                if (_x < 0){
                    _x = 0;
                }
                if (_y < 0){
                    _y = 0;
                };
                if ((_x + size_x) > x_s){
                    _x = (x_s - size_x);
                }
                if ((_y + size_y) > y_s){
                    _y = (y_s - size_y);
                }
                grid_x = _x;
                grid_y = _y;
                return;
            }
            if (_x < 0){
                if (_x < -(top_s)){
                    _x = -(top_s);
                };
            };
            if (_y < 0){
                if (_y < -(top_s)){
                    _y = -(top_s);
                };
            }
            if ((_x + size_x) > x_s){
                _x = (x_s - size_x);
            }
            if ((_y + size_y) > y_s){
                _y = (y_s - size_y);
            };
            grid_x = _x;
            grid_y = _y;
        }
        
        public function check_bounds(x_s:Number, y_s:Number):Boolean{
            if ((grid_x + size_x) > x_s){
                return false;
            }
            if ((grid_y + size_y) > y_s){
                return false;
            }
            return true;
        }
        
        public function get _width():Number{
            return ((((size_x + size_y) * _grid_size) * Math.cos(view_angle)));
        }
        
        public function get_x(grid_x:Number, grid_y:Number):Number{
            return (Algo.get_x(grid_x, grid_y, view_angle, _grid_size));
        }
        
        public function get_y(grid_x:Number, grid_y:Number):Number{
            return (Algo.get_y(grid_x, grid_y, view_angle, _grid_size));
        }
        
        public function has_irrigation():Boolean{
            return ((water_pipe_id > 0));
        }
        
        public function get sort_y_size():Number{
            return (size_y);
        }
        
        protected function add_asset():void{
            asset.addChildAt((loader.asset as DisplayObject), 0);
            //this.getHighlight();
        }
        
        public function can_upgrade():Boolean{
            if (!upgradeable){
                return false;
            }
            if (under_construction){
                return false;
            }
            if (upgrade_level == (Algo.count(upgrade_levels) + 1)){
                return false;
            }
            return true;
        }
        
        protected function get_grid_y(x:Number, y:Number):Number{
            var key:String = ((((("coord_" + x) + "_") + y) + "_") + _grid_size);
            if (!y_coord[key]){
                y_coord[key] = Algo.get_grid_y(x, y, view_angle, _grid_size);
            }
            return Number(y_coord[key]);
        }
        
        public function get_name():String{
            return _name;
        }
        
        protected function construction_complete():void{
            loader.load(asset_url);
        }
        
        
        public function update(data:Object):void{
        }
        
        public function set grid_size(v:Number):void{// 和整体的缩放有关系
            last_grid_size = _grid_size;
            _grid_x = (((map_x) || ((map_x === 0)))) ? map_x : grid_x;
            _grid_y = (((map_y) || ((map_y === 0)))) ? map_y : grid_y;
            _grid_size = v;
            refresh_coords();
            refresh_asset();
            refresh_hit_area();
            state = _state;
            rotate_btn.scaleX = (rotate_btn.scaleY = (v / 15));
        }
        
        public function get usable():Boolean{
            return !waiting_to_process;
        }
		
		
		public function same(mapObject:MapObject):Boolean {
			var result:Boolean;
			if(mapObject.size_x == this.size_x && 
				mapObject.size_y == this.size_y && 
				mapObject.grid_x == this.grid_x && 
				mapObject.grid_y == this.grid_y &&
				mapObject.map_unique_id == this.map_unique_id){
				result = true;
			}
			return result;
		}
		
		public function get saveObject():Object {
			var result:Object = {};
			result.id = this.id;
			result.x = this.sort_grid_x;
			result.y = this.sort_grid_y;
			return result;
		}
    }
}
