package classes.view.components {
    import classes.utils.*;
    import classes.view.components.map.*;
    import classes.view.components.map.tools.*;
    
    import flash.display.*;
    import flash.events.*;
    
    import tzh.DisplayUtil;
    import tzh.core.TutorialManager;

    public class Map extends Sprite {

        public static const FRIEND_VIEW:String = "friendView";// 好友的场景
        public static const SHOW_UNDER_CONSTRUCTION_POPUP:String = "showUnderConstructionPopup";
        public static const DEACTIVATE_MULTI_TOOL:String = "deactivateMultiTool";
        public static const INSTALL_IRRIGATION:String = "installIrrigation";
        public static const UPDATE_OBJECT:String = "updateObject";
        public static const SHOW_UPGRADE_POPUP:String = "showUpgradePopup";
        public static const NORMAL_VIEW:String = "normalView";

        public static const ADD_PLANT:String = "addPlant";
        public static const ADD_MAP_OBJECT:String = "addMapObject";
        public static const PROCESS_COMPLETE:String = "processComplete";
        public static const REMOVE_MAP_OBJECT:String = "removeMapObject";
        public static const REFILL_MAP_OBJECT:String = "refillMapObject";
        public static const MAP_OBJECTS_UPDATED:String = "mapObjectsUpdated";
        public static const ON_POLLINATE:String = "onPollinate";
        public static const SHOW_SHOP_AND_ADD_PLANT:String = "showShopAndAddPlant";
        public static const AUTO_COLLECT:String = "autoCollect";
        public static const FERTILIZE:String = "fertilize";
        public static const ADD_ANIMAL:String = "addAnimal";
        public static const COLLECT_PRODUCT:String = "collectProduct";
        public static const FLIP_MAP_OBJECT:String = "flipMapObject";
        public static const SHOW_CONFIRM_ERROR:String = "showConfirmError";
        public static const AUTO_REFILL:String = "autoRefill";
        public static const MOVE_MAP_OBJECT:String = "moveMapObject";
        public static const SHOW_CHRISTMAS_PRESENTS:String = "showChristmasPresents";
        public static const SELECT_RAW_MATERIAL:String = "selectRawMaterial";
        public static const TOGGLE_AUTOMATION:String = "toggleAutomation";
        public static const FEED_MAP_OBJECT:String = "feedMapObject";
        public static const APPLY_RAIN:String = "applyRain";

        public var view_mode:String = "normalView";
        private var viewport_h:Number;
        private var pan_delta_y:Number;
        private var greenhouses:Array;
        private var viewport_w:Number;
        private var bees:Array;
        private var sort_queue:Array;
        private var map_objects:Sprite;
        private var map_padd:Number = 20;
        private var pan_delta_x:Number;
        private var grid_size:Number;
        private var auto_process_loaders:Array;
        public var current_process_loader:ProcessLoader;
        private var last_mouseGridY:Number;
        public var swarm:BeesSwarm;
        private var tool_cont:Sprite;
        private var last_mouseGridX:Number;
        private var container:Sprite;
        public var map_obj:MapObject;
        public var objects_updated:Array;
        private var tool:Tool;
        private var top_size:Number;
        private var can_sort_depth:Boolean = true;
        private var grass:Grass;
        private var view_angle:Number = 1.09083078249646;
        private var size_x:Number;
        private var mouse_over_target:Object;
        private var size_y:Number;
        private var panned:Boolean = false;
        private var alpha_mode:Boolean = false;
        private var process_loader:ProcessLoader;
        private var swarms:Sprite;
        private var water_well:WaterWell;
        
        public static const BASE_SCALE_SIZE:int = 15;
        

        public function Map(_w:Number, _h:Number){
            sort_queue = new Array();
            super();
            viewport_w = _w;
            viewport_h = _h;
            init();
        }
        
        
        public function update_objects(objs:Array):void{
            var obj:Object;
            var map_obj:MapObject;
            objects_updated = new Array();
            for each (obj in objs) {
                map_obj = (map_objects.getChildByName(("obj_" + obj.unique_id)) as MapObject);
                if (map_obj){
                    map_obj.update(obj);
                    objects_updated.push({
                        id:map_obj.id,
                        x:map_obj.grid_x,
                        y:map_obj.grid_y,
                        data:obj
                    })
                }
            }
            dispatchEvent(new Event(MAP_OBJECTS_UPDATED));
        }
        
        private function object_compare(obj_A:Object, obj_B:Object):Number{
        	if(!obj_A)return 0;
        	if(!obj_B)return 0;
            var a_h:Number = obj_A.sort_y_size;
            var a_w:Number = obj_A.sort_x_size;
            var b_h:Number = obj_B.sort_y_size;
            var b_w:Number = obj_B.sort_x_size;
            var b_x:Number = obj_B.sort_grid_x;
            var b_y:Number = obj_B.sort_grid_y;
            var a_x:Number = obj_A.sort_grid_x;
            var a_y:Number = obj_A.sort_grid_y;
            if (((obj_A.is_fence) && (obj_B.is_fence))){
                if (a_w > 1){
                    a_w = (a_w - 2);
                    a_x = (a_x + 1);
                }
                if (b_w > 1){
                    b_w = (b_w - 2);
                    b_x = (b_x + 1);
                }
                if ((((a_h > 1)) && ((b_h > 1)))){
                    a_h = (a_h - 2);
                    a_y = (a_y + 1);
                }
            }
            if ((((a_y < (b_y + b_h))) && ((a_x < b_x)))){// b 在 a 的右下方
                return (-1);
            }
            if ((((a_x < (b_x + b_w))) && ((a_y < b_y)))){// b 在 a 的右下方
                return (-1);
            }
            if (((((a_y + a_h) > b_y)) && ((a_x >= (b_x + b_w))))){// b 在 a 的左下方
                return (1);
            }
            if (((((a_x + a_w) > b_x)) && ((a_y >= (b_y + b_h))))){// b 在a 的左下方
                return (1);
            }
            return (0);
        }
        
        public function check_bees():void{
            if (view_mode == FRIEND_VIEW){
                return;
            }
            var i:Number = 0;
            while (i < bees.length) {
                if (bees[i].parent){
                    Hive(bees[i]).initialize();
                }
                i++;
            }
        }
        
        private function irrigationInstalled(e:Event):void{
            water_well.start_anim();
        }
        
        private function onAutoRefill(e:Event):void{
            map_obj = (e.target as MapObject);
            dispatchEvent(new Event(AUTO_REFILL));
        }
        
        private function onFly(e:Event):void{
            var clover:Plant = find_clover_for_bees((e.target as MapObject));
            if (!clover){
                return;
            }
            clover.mark_for_pollination();
            var swarm:BeesSwarm = new BeesSwarm((e.target as Hive), clover, (grid_size / 15));
            swarms.addChild(swarm);
            swarm.set_scale((grid_size / 15));
            swarm.addEventListener(swarm.ON_POLLINATE, onPollinate);
        }
        
        private function init():void{
            container = new Sprite();
            grass = new Grass();
            map_objects = new Sprite();
            map_objects.name = "map_objects";
            tool_cont = new Sprite();
            process_loader = new ProcessLoader();
            auto_process_loaders = new Array();
            swarms = new Sprite();
            bees = new Array();
            greenhouses = new Array();
            addChild(grass);
            addChild(container);
            container.addChild(map_objects);
            container.addChild(tool_cont);
            container.addChild(process_loader);
            container.addChild(swarms);
            map_padd = 0;
            tool_cont.x = (map_objects.x = map_padd);
            tool_cont.y = (map_objects.y = map_padd);
            tool = new Tool();
            tool_cont.mouseEnabled = false;
            process_loader.visible = true;
            process_loader.addEventListener(process_loader.COMPLETE, processComplete);
            addEventListener(MouseEvent.MOUSE_MOVE, mouseMove,false,0,true);
            addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
            addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
            addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
            addEventListener(MouseEvent.MOUSE_UP, mouseUp);
            map_objects.addEventListener(Event.ADDED, onMapObjectAdded);
            map_objects.addEventListener(Event.REMOVED, onMapObjectRemoved);
        }
        
        private function mouseOver(e:MouseEvent):void{
            if (panned){
                return;
            }
            mouse_over_target = e.target;
            tool.mouse("over", e.target.parent);
        }
        
        private function sort_depth():void{
            var i:Number;
            var j:Number;
            var k:Number;
            var mo:MapObject;
            var new_obj:Object;
            var pos:Number;
            var splice_pos:Number;
            var buffer:Array;
            var obj:Object;
            var r:Number;
            var list:Array = this.getSimpleObject();
            var sorted:Array = new Array();
            var t1:Number = Algo.timer();
            i = 0;
            while (i < list.length) {
                new_obj = list[i];
                pos = -1;
                splice_pos = -1;
                buffer = new Array();
                j = 0;
                while (j < sorted.length) {// 连续的排序这个数组
                    obj = sorted[j];
                    if ((((pos == -1)) && ((object_compare(new_obj, obj) == -1)))){
                        pos = j;
                        splice_pos = j;
                    } else {
                        if (pos > -1){
                            if (object_compare(sorted[j], sorted[pos]) == 1){
                                splice_pos = j;
                            } else {
                                r = object_compare(new_obj, obj);
                                if (r == 1){
                                    buffer = buffer.concat(sorted.splice((splice_pos + 1), (j - splice_pos)));
                                    j = splice_pos;
                                };
                            };
                        };
                    };
                    j++;
                };
                if (pos == -1){
                    pos = sorted.length;
                }
                buffer.push(new_obj);
                k = (buffer.length - 1);
                while (k >= 0) {
                    sorted.splice(pos, 0, buffer[k]);
                    k--;
                };
                i++;
            }
            i = 0;
            while (i < sorted.length) {
                map_objects.setChildIndex(sorted[i].mo, i);
                i++;
            }
            var t2:int = Algo.timer();
            trace((t2 - t1) + " time..........."); 
        }
        
        private function onAutoCollect(e:Event):void{
            map_obj = (e.target as MapObject);
            dispatchEvent(new Event(AUTO_COLLECT));
        }
        
        /**
         * 
         */ 
        private function mouseMove(e:MouseEvent):void{
            if (panned){
                return;
            }
            if (mouse_over_target != e.target){
                return;
            }
            tool.mouse("move", e.target.parent);
            if (((!((last_mouseGridX == mouseGridX))) || (!((last_mouseGridY == mouseGridY))))){
                tool.mouse("grid_move", e.target.parent);
            }
            last_mouseGridX = mouseGridX;
            last_mouseGridY = mouseGridY;
        }
        
        /**
         * 整个Map的宽度 
         */ 
        private function map_width():Number{
            return (((((size_x + size_y) + (2 * top_size)) * grid_size) * Math.sin(view_angle)));
        }
        
        private function onMapObjectRemoved(e:Event):void{
            var gh:Greenhouse;
            var fence:Fence = (e.target as Fence);
            if (fence){
                align_fences(fence);// 这判断代码要分析一下,有bug可能
                fence.show_posts();
            }
            if ((e.target is Greenhouse)){
                gh = (e.target as Greenhouse);
                gh.join();
                onGreenhouseRemoved(gh);
            }
            if ((e.target is Plant)){
                Plant(e.target).greenhouse_removed();
            }
            if (e.target as WaterWell){
                water_well = null;
            }
        }
        
        /**
         * 向greenhouse里添加东西 
         */ 
        private function onGreenhouseAdded(g:Greenhouse):void{
            var i:Number = 0;
            var obj:MapObject;
            while (i < map_objects.numChildren) {
                obj = (map_objects.getChildAt(i) as MapObject);
                if (!obj){
                } else {
                    if (obj.type != MapObject.MAP_OBJECT_TYPE_SOIL && obj.type != MapObject.MAP_OBJECT_TYPE_SEEDS){
                    } else {
                        if (((obj.intersect(g)) && (!(obj.intersect(g, true))))){
                            obj.greenhouse_added(g);
                            map_obj = obj;
                            if ((obj is Plant)){
                                dispatchEvent(new Event(UPDATE_OBJECT));
                            }
                            g.add_plant(obj);
                        }
                    }
                }
                i++;
            }
        }
        
        /**
         * 当前鼠标点击到的格子的坐标Y 
         */ 
        public function get mouseGridY():Number{
            return (Algo.get_grid_y(map_objects.mouseX, map_objects.mouseY, view_angle, grid_size));
        }
        
        public function get event_data():Object{
            return tool.get_event_data();
        }
        
        /**
         * 删除map里的所有内容
         */ 
        private function clear_map_objects():void{
            tool.remove();
            while (map_objects.numChildren > 0) {
                MapObject(map_objects.getChildAt(0)).kill();
            }
        }
        
        public function get mouseGridX():Number{
            return (Algo.get_grid_x(map_objects.mouseX, map_objects.mouseY, view_angle, grid_size));
        }
        
        
        private function doubleClick(e:MouseEvent):void{
            if (panned){
                return;
            }
            tool.mouse("double_click", e.target.parent);
        }
        
        
        public function cancel_process_loader():void{
            process_loader.stop();
            var i:Number = 0;
            while (i < auto_process_loaders.length) {
                ProcessLoader(auto_process_loaders[i]).stop();
                i++;
            }
            auto_process_loaders = new Array();
        }
        
        private function stopPan(e:MouseEvent):void{
            removeEventListener(MouseEvent.MOUSE_MOVE, panMap);
            tool.enabled = true;
            if (panned){
                panned = false;
                mouseOver(e);
            }
            stage.quality = StageQuality.HIGH;
        }
        
        public function increase_obtained_material(obj:Object, material:Number):MapObject{
            var mo:MapObject;
            var i:Number = 0;
            while (i < map_objects.numChildren) {
                mo = map_objects.getChildAt(i) as MapObject;
                if (mo.id == obj.id && mo.grid_x == obj.x && mo.grid_y == obj.y){
                    mo.increase_obtained_material(material);
                    return mo;
                }
                i++;
            }
            return null;
        }
        
        /**
         * 设置鼠标显示的图形 
         */ 
        public function set_tool(name:String, data:Object=null):void{
            tool.remove();
            switch (name){
                case "add_MO":
                    tool = new AddMapObjectTool(data);
                    break;
                case "move":
                    tool = new MoveTool(data);
                    break;
                case "remove":
                    tool = new RemoveTool(data);
                    break;
                case "multi_tool":
                    tool = new MultiTool(data);
                    break;
                case "use_shop_item":
                    tool = new UseShopItemTool(data);
                    dispatchEvent(new Event(DEACTIVATE_MULTI_TOOL));
                    break;
                case "show_info":
                    tool = new ShowInfoTool();
                    break;
                case "automation":
                    tool = new AutomationTool();
                    break;
                default:
                    tool = new Tool(data);
            }
            tool.init(tool_cont, map_objects);
            tool.set_bounds(size_x, size_y, top_size);
            tool.refresh_grid_size(grid_size);
            tool.addEventListener(tool.CONFIRM_ACTION, confirmToolAction);
            tool.addEventListener(tool.ON_DISABLE, disableTool);
            tool.activate();
        }
        
        private function mouseUp(e:MouseEvent):void{
            if (!panned){
                tool.mouse("up", e.target.parent);
            }
        }
        
        public function clear():void{
            var swarm:BeesSwarm;
            var i:Number = 0;
            while (i < swarms.numChildren) {
                swarm = (swarms.getChildAt(i) as BeesSwarm);
                swarm.kill();
                swarm.removeEventListener(swarm.ON_POLLINATE, onPollinate);
                i++;
            }
            bees = new Array();
            clear_map_objects();
        }
        
        
        public function tool_action_confirmed(data:Object=null):void{
            tool.action_confirmed(data);
            refresh_objects_depth();
        }
        
        
        private function check_greenhouses(obj:MapObject):void{
            var gh:Greenhouse;
            var i:Number = 0;
            while (i < map_objects.numChildren) {
                gh = (map_objects.getChildAt(i) as Greenhouse);
                if (gh){
                    if (((gh.intersect(obj)) && (!(gh.intersect(obj, true))))){
                        obj.greenhouse_added(gh);
                        if ((obj is Plant)){
                            map_obj = obj;
                            dispatchEvent(new Event(UPDATE_OBJECT));
                        }
                        gh.add_plant(obj);
                    }
                }
                i++;
            }
        }
        
        
        public function escape_pressed():void{
            tool.remove();
            set_tool("multi_tool");
            tool.mouse("over", mouse_target);
        }
        
        /**
         * 进度显示条显示 
         */ 
        public function show_process_loader(data:Object):void{
            var pl:ProcessLoader;
            if (!data.auto_mode){
                process_loader.visible = true;
                process_loader.start(data);
            } else {
                pl = new ProcessLoader();
                container.addChild(pl);
                pl.addEventListener(pl.COMPLETE, processComplete);
                auto_process_loaders.push(pl);
                pl.visible = true;
                pl.start(data);
            }
        }
        
        /**
         * 整个Map的高度 
         */ 
        private function map_height():Number{
            return (((((size_x + size_y) + (2 * top_size)) * grid_size) * Math.cos(view_angle)));
        }
        
        /**
         * 获取当前鼠标的显示对象 
         */ 
        private function get mouse_target():MapObject{
            var obj:MapObject;
            var x:Number = map_objects.mouseX;
            var y:Number = map_objects.mouseY;
            var i:Number = 0;
            while (i < map_objects.numChildren) {
                obj = (map_objects.getChildAt(i) as MapObject);
                /* if (obj.hit_test(map_objects.mouseX, map_objects.mouseY)){ */
                if (obj.hit_test(map_objects.mouseX, map_objects.mouseY)){
                    return obj;
                }
                i++;
            }
            return null;
        }
        
        
        private function mouseOut(e:MouseEvent):void{
            if (panned){
                return;
            }
            tool.mouse("out", e.target.parent);
        }
        
        /**
         * 整个地图从此处加载 
         */ 
        private function create_map_objects(objects:Object):void{
            var data:Object;
            var obj:MapObject;
            can_sort_depth = false;
            bees = new Array();
            clear_map_objects();
            for each (data in objects) {
                switch (data.type){
                    case "seeds":
                        obj = new Plant(data);
                        obj.addEventListener(Plant.IRRIGATION_INSTALLED, irrigationInstalled);
                        obj.addEventListener(Plant.FRIEND_HELPED_FERTILIZE,friendHelpedFertilize);
                        break;
                    case "animals":
                        switch (data.kind){
                            case "cow":
                                obj = new Cow(data);
                                break;
                            case "rabbit":
                                obj = new Rabbit(data);
                                break;
                            case "sheep":
                                obj = new Sheep(data);
                                break;
                            case "hive":
                                obj = new Hive(data);
                                if (view_mode != FRIEND_VIEW){
                                    obj.addEventListener(Hive.FLY, onFly);
                                    bees.push(obj);
                                };
                                break;
                            default:
                                obj = new MapObject(data);
                        };
                        break;
                    case "gear":
                        switch (data.kind){
                            case "ketchup":
                                obj = new Ketchup(data);
                                break;
                            case "cheese":
                                obj = new Cheese(data);
                                break;
                            case "chicken_coop":
                                obj = new ChickenCoop(data);
                                break;
                            case "wine":
                                obj = new WineMachine(data);
                                break;
                            case "jam":
                                obj = new JamMachine(data);
                                break;
                            case "bread":
                                obj = new BreadMachine(data);
                                break;
                            case "textile":
                                obj = new TextileMachine(data);
                                break;
                            case "packing":
                                obj = new PackingMachine(data);
                                break;
                        };
                        break;
                    case "buildings":
                        switch (data.kind){
                            case "multi_mill":
                                obj = new MultiMill(data);
                                break;
                            case "mill":
                                obj = new Mill(data);
                                break;
                            case "greenhouse":
                                obj = new Greenhouse(data);
                                obj.addEventListener(Greenhouse.SPLIT_OBJECT, onSplitObject);
                                greenhouses.push(obj);
                                break;
                            case "house":
                                obj = new Decoration(data);
                                break;
                            case "water_well":
                                obj = new WaterWell(data);
                                water_well = (obj as WaterWell);
                                water_well.addEventListener(WaterWell.CHECK_IRRIGATION, check_irrigation);
                                break;
                        };
                        break;
                    case "special_events":
                        switch (data.kind){
                            case "fertilizer":
                                obj = new Fertilizer(data);
                                break;
                        };
                        break;
                    case "trees":
                        obj = new Tree(data);
                        break;
                    case "decorations":
                        switch (data.kind){
                            case "christmas_tree":
                                obj = new ChristmasTree(data);
                                break;
                            case "fence":
                                obj = new Fence(data);
                                break;
                            case "animation":
                            	obj = new AnimationDecoration(data);
                            	break;
                            default:
                                obj = new Decoration(data);
                        };
                        break;
                    default:
                        obj = new MapObject(data);
                }
                obj.grid_size = grid_size;
                if (obj as IProcessor && view_mode != FRIEND_VIEW){
                    obj.addEventListener(Processor.AUTO_REFILL, onAutoRefill);
                    obj.addEventListener(Processor.AUTO_COLLECT, onAutoCollect);
                }
                map_objects.addChild(obj);
            }
            can_sort_depth = true;
            sort_depth();
            align_fences();
            refresh_objects_depth();
            init_greenhouses();
            check_irrigation();
        }
        
        
        private function friendHelpedFertilize(event:Event):void {
        	this.dispatchEvent(new Event(Plant.FRIEND_HELPED_FERTILIZE));
        }
        
        public function refresh_objects_depth():void{
            check_bees();
        }
        
        /**
         * 拖动时,重新绘制析的位置 
         */ 
        private function panMap(e:MouseEvent):void{
        	var showTutorial:Boolean = TutorialManager.getInstance().end;
        	if(!showTutorial)return;
            var d:Number = Algo.distance((mouseX - container.x), (mouseY - container.y), pan_delta_x, pan_delta_y);
            if ((((d < 8)) && (!(panned)))){
                return;
            }
            tool.enabled = false;
            container.x = (mouseX - pan_delta_x);
            container.y = (mouseY - pan_delta_y);
            check_map_bounds();
            update_grass();
            if (!panned){
                mouseOut(e);
            }
            panned = true;
            stage.quality = StageQuality.LOW;
        }
       
        /**
         * 这是一个重要的算法
         * 二分查找 留着以后用,优化时会用到
         */ 
        private var depthSortedObjects:Array = [];
        private function binarySearch(value:MapObject):int{
            var mapObject:MapObject;
            var low:int;// 最小的一个长度
            var high:int = depthSortedObjects.length;// 最大的一个长度
            var half:int = (low + high) >> 1;
            var result:int;
            while (low < high) {
                mapObject = depthSortedObjects[half] as MapObject;
                result = object_compare(value.simple_object(), mapObject.simple_object());
                if (result == -1){// a 在 b 后 左移一半
                    high = half;
                    half = (low + high) >> 1;
                }else if (result == 1){// a 在 b 前
                    low = half + 1;
                    half = (low + high) >> 1;
                } else {
                    break;
                }
            }
            return half;
        }
        
        public function getSimpleObject(value:MapObject = null):Array {
        	var index:int = 0;
        	var result:Array = [];
        	var invalidate:Boolean = value != null;
        	while(index < map_objects.numChildren){
        		var mapObject:MapObject = map_objects.getChildAt(index) as MapObject;
        		if(invalidate){
        			if(value != mapObject){
        				result.push(mapObject.simple_object());
        			}
        		}else {
        			result.push(mapObject.simple_object());
        		}
        		index++;
        	}
        	return result;
        }
        
        private function set_object_depth(new_mo:MapObject):void{
            var i:Number;
            var j:Number;
            var k:Number;
            var mo:MapObject;
            var so:Object;
            var obj:Object;
            var r:Number;
            var sorted:Array = this.getSimpleObject(new_mo);
            var new_obj:Object = new_mo.simple_object();
            var pos:Number = -1;
            var splice_pos:Number = -1;
            var buffer:Array = new Array();
            j = 0;
            while (j < sorted.length) {
                obj = sorted[j];
                if ((((pos == -1)) && ((object_compare(new_obj, obj) == -1)))){
                    pos = j;
                    splice_pos = j;
                } else {
                    if (pos > -1){
                        if (object_compare(sorted[j], sorted[pos]) == 1){
                            splice_pos = j;
                        } else {
                            r = object_compare(new_obj, obj);
                            if (r == 1){
                                buffer = buffer.concat(sorted.splice((splice_pos + 1), (j - splice_pos)));
                                j = splice_pos;
                            };
                        };
                    };
                };
                j++;
            };
            if (pos == -1){
                pos = sorted.length;
            };
            buffer.push(new_obj);
            k = (buffer.length - 1);
            while (k >= 0) {
                sorted.splice(pos, 0, buffer[k]);
                k--;
            }
            i = 0;
            while (i < sorted.length) {
                map_objects.setChildIndex(sorted[i].mo, i);
                i++;
            };
        }
        
        public function update(data:Object):void{
            size_x = data.size_x;
            size_y = data.size_y;
            top_size = data.top_map_size;
            create_map_objects(data.objects);
            center_map();
        }
        
        public function center_map():void{
            container.y = (((stage.stageHeight - map_height()) + (((2 * top_size) * grid_size) * Math.cos(view_angle))) / 2);
            container.x = (stage.stageWidth / 2);
            grass.set_bounds(size_x, size_y, top_size);
            update_grass();
        }
        
        private function onGreenhouseRemoved(g:Greenhouse):void{
            var plants:Array = g.get_plants();
            var i:Number = 0;
            while (i < plants.length) {
                MapObject(plants[i]).greenhouse_removed();
                map_obj = (plants[i] as MapObject);
                if (map_obj is Plant){
                    dispatchEvent(new Event(UPDATE_OBJECT));
                }
                i++;
            }
            g.clear_plants();
        }
        
        public function refresh_viewport():void{
            viewport_w = stage.stageWidth;
            viewport_h = stage.stageHeight;
            update_grass();
        }
        
        public function add_object(obj:MapObject):void{
            obj.grid_size = grid_size;
            map_objects.addChild(obj);
        }
        
        private function check_map_bounds():void{
            var dw:Number = (((2 * map_padd) + map_width()) - viewport_w);
            var dh:Number = (((2 * map_padd) + map_height()) - viewport_h);
            var offset_h:Number = ((top_size * grid_size) * Math.sin(view_angle));
            if (container.y < (-(dh) - (viewport_h / 2))){
                container.y = (-(dh) - (viewport_h / 2));
            }
            if ((container.x - (map_width() / 2)) < (-(dw) - (viewport_w / 2))){
                container.x = ((-(dw) - (viewport_w / 2)) + (map_width() / 2));
            }
            if ((container.y - offset_h) > (viewport_h / 2)){
                container.y = ((viewport_h / 2) + offset_h);
            }
            if ((container.x - (map_width() / 2)) > (viewport_w / 2)){
                container.x = ((viewport_w / 2) + (map_width() / 2));
            }
        }
        
        /**
         * 自动画寻找过程,
         * 定义一个很大的变量
         * 然后去根据这个对比,找到最近的点 
         */ 
        private function find_clover_for_bees(hive:MapObject):Plant{
            var last_plant:Plant;
            var plant:Plant;
            var distance:Number;
            var maxDistance:Number = 10000000;
            var i:Number = 0;
            while (i < map_objects.numChildren) {
                plant = (map_objects.getChildAt(i) as Plant);
                if(plant && 
                	plant.kind == "clover" && 
                	(!plant.is_marked_for_pollination()) && 
                	(!plant.is_pollinated()) && 
                	(!plant.can_be_fertilized())){
                    distance = Algo.distance(hive.x, hive.y, plant.x, plant.y);
                    if (distance < maxDistance){
                        maxDistance = distance;
                        last_plant = plant;
                    }
                }
                i++;
            }
            return last_plant;
        }
        
        private function check_irrigation(e:Event = null):void{
            var plant:Plant;
            if (!water_well){
                return;
            }
            var i:Number = 0;
            while (i < map_objects.numChildren) {
                plant = (map_objects.getChildAt(i) as Plant);
                if (!plant){
                } else {
                    if (((!(plant.has_irrigation())) || (plant.is_ready()))){
                    } else {
                        water_well.start_anim();
                        break;
                    }
                }
                i++;
            }
        }
        private function onSplitObject(e:Event):void{
            var greenhouse:Greenhouse = Greenhouse(e.target);
            var bottom_obj:GraphicObject = greenhouse.bottom_object();
            var top_obj:GraphicObject = greenhouse.top_object();
            var right_obj:GraphicObject = greenhouse.right_object();
            var left_obj:GraphicObject = greenhouse.left_object();
            if (!bottom_obj){
                return;
            }
            bottom_obj.grid_size = grid_size;
            top_obj.grid_size = grid_size;
            right_obj.grid_size = grid_size;
            left_obj.grid_size = grid_size;
            top_obj.grid_x = greenhouse.grid_x;
            top_obj.grid_y = greenhouse.grid_y;
            left_obj.grid_x = greenhouse.grid_x;
            left_obj.grid_y = greenhouse.grid_y;
            left_obj.set_sort_coords(greenhouse.grid_x, (greenhouse.grid_y + 1), (greenhouse.grid_x + 1), greenhouse.grid_y);
            right_obj.grid_x = greenhouse.grid_x;
            right_obj.grid_y = greenhouse.grid_y;
            right_obj.set_sort_coords(((greenhouse.grid_x + greenhouse.x_size) - 1), (greenhouse.grid_y + 1), (greenhouse.grid_x + 1), ((greenhouse.grid_y + greenhouse.y_size) - 1));
            bottom_obj.grid_x = greenhouse.grid_x;
            bottom_obj.grid_y = greenhouse.grid_y;
            bottom_obj.set_sort_coords(greenhouse.grid_x, ((greenhouse.grid_y + greenhouse.y_size) - 1), ((greenhouse.grid_x + greenhouse.x_size) - 1), greenhouse.grid_y);
            if (bottom_obj.parent == map_objects){
                map_objects.addChild(bottom_obj);
                set_object_depth(bottom_obj); 
            } else {
                map_objects.addChild(bottom_obj);
            };
            if (top_obj.parent == map_objects){
                map_objects.addChild(top_obj);
                set_object_depth(top_obj); 
            } else {
                map_objects.addChild(top_obj);
            }
            if (left_obj.parent == map_objects){
                map_objects.addChild(left_obj);
                set_object_depth(left_obj); 
            } else {
                map_objects.addChild(left_obj);
            };
            if (right_obj.parent == map_objects){
                map_objects.addChild(right_obj);
                set_object_depth(right_obj); 
            } else {
                map_objects.addChild(right_obj);
            }
            bottom_obj.refresh_graphic();
            top_obj.refresh_graphic();
            right_obj.refresh_graphic();
            left_obj.refresh_graphic();
        }
        
        public function map_object_removed(obj:MapObject):void{
            var i:Number;
            var mo:MapObject;
            if ((obj as WaterWell)){
                i = 0;
                while (i < map_objects.numChildren) {
                    mo = (map_objects.getChildAt(i) as MapObject);
                    if (mo.has_irrigation()){
                        mo.remove_irrigation();
                        if ((mo as Plant)){
                            map_obj = obj;
                            dispatchEvent(new Event(UPDATE_OBJECT));
                        }
                    }
                    i++;
                }
            }
        }
        
        private function init_greenhouses():void{
            var i:Number = 0;
            while (i < greenhouses.length) {
                onGreenhouseAdded(Greenhouse(greenhouses[i]));
                i++;
            }
        }
        
        private function disableTool(e:Event):void{
            set_tool("multi_tool");
        }
        
        /**
         * 扩大地块的操作 
         */ 
        public function expand(item:Object):void{
            switch (item.action){
                case "expand":
                    size_y = (size_x = item.size);
                    break;
                case "expand_top_map":
                    top_size = item.size;
                    break;
            }
            tool.set_bounds(size_x, size_y, top_size);
            center_map();
        }
        
        public function toggle_alpha():void{
            var map_object:MapObject;
            alpha_mode = !(alpha_mode);
            var i:Number = 0;
            while (i < map_objects.numChildren) {
                map_object = (map_objects.getChildAt(i) as MapObject);
                map_object.toggle_alpha(alpha_mode);
                i++;
            }
        }
        
        public function check_automation(mode:String):void{
            var map_object:IProcessor;
            var i:Number = 0;
            while (i < map_objects.numChildren) {
                map_object = (map_objects.getChildAt(i) as IProcessor);
                if (!map_object){
                } else {
                    map_object.check_automation(mode);
                }
                i++;
            }
        }
        
        public function set_zoom(grid_size:Number):void{
            var obj:MapObject;
            var swarm:BeesSwarm;
            var dx:Number = ((viewport_w / 2) - container.x);
            var dy:Number = ((viewport_h / 2) - container.y);
            var r:Number = (this.grid_size) ? (grid_size / this.grid_size) : 1;
            this.grid_size = grid_size;
            grass.set_grid_size(grid_size);
            var i:Number = 0;
            while (i < map_objects.numChildren) {
                obj = MapObject(map_objects.getChildAt(i));
                obj.grid_size = grid_size;
                i++;
            }
            tool.refresh_grid_size(grid_size);
            container.x = ((viewport_w / 2) - (r * dx));
            container.y = ((viewport_h / 2) - (r * dy));
            update_grass();
            i = 0;
            while (i < swarms.numChildren) {
                swarm = (swarms.getChildAt(i) as BeesSwarm);
                swarm.set_scale((grid_size / 15));
                i++;
            }
        }
        
        public function apply_rain(p:Number):void{
            var obj:CollectObject;
            var i:Number = 0;
            while (i < map_objects.numChildren) {
                obj = (map_objects.getChildAt(i) as CollectObject);
                if ((obj as Plant) || (obj as Tree)){
                    obj.apply_rain(p, true);
                }
                i++;
            }
            check_bees();
        }
        
        private function onMapObjectAdded(e:Event):void{
            if (!can_sort_depth){
                return;
            }
            var obj:MapObject = (e.target as MapObject);
            if (((obj) && ((obj.parent == map_objects)))){
                if ((obj as Greenhouse)){
                    if (!obj.hasEventListener(Greenhouse.SPLIT_OBJECT)){
                        obj.addEventListener(Greenhouse.SPLIT_OBJECT, onSplitObject);
                    };
                    onSplitObject(e);
                    onGreenhouseAdded((obj as Greenhouse));
                }
                set_object_depth(obj);
                if ((obj as Fence)){
                    align_fences();
                }
                if (obj as Plant || obj.type == MapObject.MAP_OBJECT_TYPE_SOIL){
                    check_greenhouses(obj);
                }
                check_bees();
                if (obj.kind == "hive"){
                    obj.addEventListener(Hive.FLY, onFly);
                    Hive(obj).initialize();
                    bees.push(obj);
                }
                if ((((obj as IProcessor)) && (!((view_mode == FRIEND_VIEW))))){
                    obj.addEventListener(Processor.AUTO_COLLECT, onAutoCollect);
                    obj.addEventListener(Processor.AUTO_REFILL, onAutoRefill);
                }
                if ((obj as Plant)){
                    obj.addEventListener(Plant.IRRIGATION_INSTALLED, irrigationInstalled);
                    if (obj.has_irrigation()){
                        water_well.start_anim();
                    }
                }
                if ((obj as WaterWell)){
                    water_well = (obj as WaterWell);
                    obj.addEventListener(WaterWell.CHECK_IRRIGATION, check_irrigation);
                }
            }
        }
        
        private function confirmToolAction(e:Event):void{
            if (e.target.action == e.target.MAP_ADD_OBJECT){
                add_object(e.target.get_event_data());
            } else {
                dispatchEvent(new Event(e.target.action));
            }
        }
        
        private function processComplete(e:Event):void{
            current_process_loader = (e.target as ProcessLoader);
            if (current_process_loader.auto_mode){
                current_process_loader.visible = false;
                current_process_loader.remove();
                //current_process_loader.removeEventListener(Event.COMPLETE,processComplete);
                auto_process_loaders.splice(auto_process_loaders.indexOf(current_process_loader),1);
                trace("auto_process_loaders " + auto_process_loaders.length + " container " + container.numChildren );
                //current_process_loader = null;
                //container.removeChild(current_process_loader);
            } else {
                process_loader.visible = false;
            }
            dispatchEvent(new Event(PROCESS_COMPLETE));
        }
        
        private function onPollinate(e:Event):void{
            swarm = (e.target as BeesSwarm);
            dispatchEvent(new Event(ON_POLLINATE));
        }
        private function update_grass():void{
            grass.draw(stage.stageWidth, stage.stageHeight, (container.x - (stage.stageWidth / 2)), (container.y - ((stage.stageHeight - map_height()) / 2)));
        }
        
        private function mouseDown(e:MouseEvent):void{
            panned = false;
            tool.mouse("down", e.target.parent);
            pan_delta_x = (mouseX - container.x);
            pan_delta_y = (mouseY - container.y);
            addEventListener(MouseEvent.MOUSE_MOVE, panMap);
            stage.addEventListener(MouseEvent.MOUSE_UP, stopPan);
        }
        
        public function get_tool():String{
            return tool.TYPE;
        }
        
        /**
         * 找到具体指定的位置的MapObject
         * @param grid_x:Number x轴的效果
         * @param  grid_y:Number
         */ 
        public function getMapObject(grid_x:Number,grid_y:Number):MapObject {
        	var result:MapObject = null;
        	for(var i:int = 0; i < map_objects.numChildren; i++){
        		var mapObject:MapObject = map_objects.getChildAt(i) as MapObject;
        		if(mapObject && mapObject.grid_x == grid_x && mapObject.grid_y == grid_y){
        			result = mapObject;
        			break;
        		}
        	}
        	return result;
        }
        
        public function set enabled(value:Boolean):void {
        	for(var i:int = 0; i < map_objects.numChildren; i++){
        		var mapObject:MapObject = map_objects.getChildAt(i) as MapObject;
        		mapObject.mouseChildren = value;
        	}
        }
        
        /**
         * 获取当前场景里所有的processer,给用户关闭自动画的功能时用到的 
         */ 
        public function get allProcessers():Array {
        	var result:Array = [];
        	for(var i:int = 0; i < map_objects.numChildren; i++){
        		var child:DisplayObject = map_objects.getChildAt(i);
        		if(child is Processor){
        			result.push(child);
        		}
        	}
        	return result;
        }
        
        private function align_fences(ignored_fence:Fence=null):void{
            var i:Number;
            var j:Number;
            var mo:MapObject;
            var fence:Fence;
            var f1x1:Number;
            var f1x2:Number;
            var f1y1:Number;
            var f1y2:Number;
            var _fence:Fence;
            var f2x1:Number;
            var f2x2:Number;
            var f2y1:Number;
            var f2y2:Number;
            var d1:Number;
            var d2:Number;
            var fences:Array = new Array();
            i = 0;
            while (i < map_objects.numChildren) {
                mo = (map_objects.getChildAt(i) as MapObject);
                if ((mo as Fence)){
                    if (((ignored_fence) && ((mo == ignored_fence)))){
                    } else {
                        fences.push(mo);
                        Fence(mo).show_posts();
                    };
                };
                i++;
            };
            i = 0;
            while (i < (fences.length - 1)) {
                fence = (fences[i] as Fence);
                f1x1 = fence.grid_x;
                f1x2 = (fence.grid_x + fence.x_size);
                f1y1 = fence.grid_y;
                f1y2 = (fence.grid_y + fence.y_size);
                j = (i + 1);
                while (j < fences.length) {
                    _fence = (fences[j] as Fence);
                    if (_fence.intersect(fence)){
                        f2x1 = _fence.grid_x;
                        f2x2 = (_fence.grid_x + _fence.x_size);
                        f2y1 = _fence.grid_y;
                        f2y2 = (_fence.grid_y + _fence.y_size);
                        d1 = map_objects.getChildIndex(fence);
                        d2 = map_objects.getChildIndex(_fence);
                        if (((((((f1x1 + 1) == f2x2)) && ((f1y1 == f2y1)))) && (!((f1x1 == f2x1))))){
                            _fence.hide_second_post();
                        };
                        if (((((((f1y1 + 1) == f2y2)) && ((f1x1 == f2x1)))) && (!((f1y1 == f2y1))))){
                            _fence.hide_second_post();
                        };
                        if ((((f1x1 == f2x1)) && ((f1y1 == f2y1)))){
                            if (!fence.is_flipped()){
                                fence.hide_first_post();
                            } else {
                                _fence.hide_first_post();
                            };
                        };
                        if (!fence.is_flipped()){
                            if ((((f1x2 == f2x2)) && ((f1y2 == f2y2)))){
                                fence.hide_second_post();
                            };
                            if ((((f1x2 == f2x2)) && ((f1y1 == f2y1)))){
                                fence.hide_second_post();
                            };
                            if ((((f1y1 == f2y1)) && ((f1x2 == (f2x1 + 1))))){
                                fence.hide_second_post();
                            };
                        } else {
                            if ((((f1x2 == f2x2)) && ((f1y2 == f2y2)))){
                                _fence.hide_second_post();
                            };
                            if ((((f1x1 == f2x1)) && ((f1y2 == f2y2)))){
                                fence.hide_second_post();
                            };
                            if ((((f1x1 == f2x1)) && ((f1y2 == (f2y1 + 1))))){
                                fence.hide_second_post();
                            };
                        };
                    };
                    j++;
                }
                i++;
            }
        }

    }
}
