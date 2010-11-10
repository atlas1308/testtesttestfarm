package classes.view.components.map.tools
{
    import classes.utils.*;
    import classes.view.components.map.MapObject;
    import classes.view.components.map.Plant;
    import classes.view.components.map.Tooltip;
    
    import flash.display.*;
    import flash.events.*;

    public class Tool extends EventDispatcher
    {
        protected var _enabled:Boolean = true;
        protected var action_name:String;
        protected var map_size_y:Number;
        protected var map_object:MapObject;
        protected var target:MapObject;
        protected var tip_icon:MovieClip;
        public const MAP_ADD_OBJECT:String = "MapAddObject";
        protected var map_top_size:Number;
        public const CONFIRM_ACTION:String = "confirmAction";
        protected var map_grid_size:Number;
        protected var map_objects:Sprite;
        protected var data:Object;
        public var TYPE:String = "tool";
        public const SHOW_CONFIRM_ERROR:String = "showConfirmError";
        protected var activated:Boolean = false;
        protected var real_target:DisplayObjectContainer;
        protected var last_intersected:MapObject;
        protected var error_message:String;
        protected var use_tip_icon:Boolean = false;
        public const ON_DISABLE:String = "onDisable";
        protected var tool_tip:Tooltip;
        protected var tool_cont:Sprite;
        protected var map_size_x:Number;
        protected var object_intersected:MapObject;

        public function Tool(value:Object = null)
        {
            this.data = value;
            tool_tip = new Tooltip();
        }

        protected function disable() : void
        {
            dispatchEvent(new Event(ON_DISABLE));
        }

        public function init(tool_cont:Sprite, map_objects:Sprite) : void
        {
            this.tool_cont = tool_cont;
            this.map_objects = map_objects;
        }

        protected function mouseLeave() : void
        {
            return;
        }

        public function remove() : void
        {
            target = null;
        }

        protected function hide_cursor() : void
        {
            Cursor.hide();
        }

        public function action_confirmed(... args) : void
        {
            return;
        }

        protected function mouseOver() : void
        {
            return;
        }

        public function set enabled(value:Boolean) : void
        {
            _enabled = value;
        }

        protected function tip(text:String, mapObject:MapObject = null, color:Number = -1) : void
        {
        	if(!tool_cont)return;
            if (!tool_cont.contains(tool_tip))
            {
                tool_cont.addChild(tool_tip);
            }
            var mapObject:* = mapObject ? mapObject : target;
            if (!mapObject)
            {
                return hide_tip();
            }
            if (color > -1)
            {
                tool_tip.setTextColor(color);
            }
            if(mapObject is Plant){
            	if(Plant(mapObject).friend_fert_message){
            		text += "\n" + Plant(mapObject).friend_fert_message;
            	}
            }
            tool_tip.setText(text);
            tool_tip.x = mapObject.x - tool_tip.width / 2;
            tool_tip.y = mapObject.y - tool_tip.height;
            tool_tip.visible = true;
            if (use_tip_icon && tip_icon)
            {
                tip_icon.x = mapObject.x - tip_icon.width / 2;
                tip_icon.y = tool_tip.y - tip_icon.height - 4;
                if (!tool_cont.contains(tip_icon))
                {
                    tool_cont.addChild(tip_icon);
                }
            }
            else if (tip_icon && tool_cont.contains(tip_icon))
            {
                tool_cont.removeChild(tip_icon);
            }
        }

        protected function hide_tip() : void
        {
            tool_tip.visible = false;
            if (tip_icon)
            {
                if (tool_cont.contains(tip_icon))
                {
                    tool_cont.removeChild(tip_icon);
                }
            }
        }

        protected function object_intersect(value:MapObject) : Boolean
        {
            var mapObject:MapObject = null;
            if (last_intersected)
            {
                last_intersected.state = "clear";
            }
            var index:Number = 0;
            while (index < map_objects.numChildren)
            {
                mapObject = MapObject(map_objects.getChildAt(index));
                if (mapObject.intersect(value, true))
                {
                    last_intersected = mapObject;
                    mapObject.state = "intersect_whitout_corners";
                    value.state = "intersect";
                    object_intersected = mapObject;
                    return true;
                }
                index++;
            }
            object_intersected = null;
            return false;
        }

        public function mouse(state:String, target:Object) : void
        {
            if (!_enabled)
            {
                return;
            }
            this.target = target as MapObject;
            handle_state(state);
        }
        
        public function get mouseTarget():MapObject {
        	return this.target;
        }

        protected function mouseUp() : void
        {
            return;
        }

        protected function show_above_objects(value:MapObject) : void
        {
            var list:Array = get_above_objects(value);
            var index:Number = 0;
            while (index < list.length)
            {
                MapObject(list[index]).alpha = 1;
                index++;
            }
        }

        public function set_bounds(map_size_x:Number, map_size_y:Number, map_top_size:Number) : void
        {
            this.map_size_x = map_size_x;
            this.map_size_y = map_size_y;
            this.map_top_size = map_top_size;
        }

        public function get action() : String
        {
            return action_name;
        }

        protected function hide_above_objects(value:MapObject) : void
        {
            var list:Array = get_above_objects(value);
            var index:Number = 0;
            while (index < list.length)
            {
                MapObject(list[index]).alpha = 0.4;
                index++;
            }
        }

        protected function doubleClick() : void
        {
            return;
        }

        public function get_event_data() : Object
        {
            return map_object;
        }

        protected function mouseGridMove() : void
        {
            return;
        }

        protected function mouseMove() : void
        {
            return;
        }
		
		/**
		 * 要重写这个方法
		 */ 
        protected function get_above_objects(value:MapObject) : Array
        {
            var list:Array = [];;
            var index:int = 0;
            var maxDistance:int = 12;
            while(index < map_objects.numChildren){
            	var mapObject:MapObject = map_objects.getChildAt(index) as MapObject;
            	if(mapObject.type != MapObject.MAP_OBJECT_TYPE_SEEDS && mapObject.type != MapObject.MAP_OBJECT_TYPE_SOIL){
            		var hitabled:Boolean = mapObject.hit_test_object(value);
	            	if(hitabled){
	            		if(mapObject.bottom >= value.bottom && (mapObject.grid_y - value.grid_y <= maxDistance) &&
		            		mapObject.right >= value.right && (mapObject.grid_x - value.grid_x) <= maxDistance){
		            		list.push(mapObject);
	            		}
	            	}
            	}
            	index++;
            }
            return list;
        }

        public function clear() : void
        {
            if (!tool_cont)
            {
                return;
            }
            while (tool_cont.numChildren)
            {
                tool_cont.removeChildAt(0);
            }
            Cursor.hide();
        }

        protected function confirm(value:String = "") : void
        {
            if (value != "")
            {
                action_name = value;
            }
            dispatchEvent(new Event(CONFIRM_ACTION));
        }

        protected function set_cursor(value:String) : void
        {
            Cursor.show(value);
        }

        protected function handle_state(value:String) : void
        {
            switch(value)
            {
                case "grid_move":
                {
                    mouseGridMove();
                    break;
                }
                case "move":
                {
                    mouseMove();
                    break;
                }
                case "out":
                {
                    mouseOut();
                    break;
                }
                case "over":
                {
                    mouseOver();
                    break;
                }
                case "down":
                {
                    mouseDown();
                    break;
                }
                case "up":
                {
                    mouseUp();
                    break;
                }
                case "double_click":
                {
                    doubleClick();
                    break;
                }
                default:
                {
                    break;
                }
            }
        }

        protected function mouseOut() : void
        {
            return;
        }

        public function activate() : void
        {
            activated = true;
            enabled = true;
            clear();
            tool_tip.visible = false;
            try {
            	this.tool_cont.addChild(tool_tip);
            }catch(error:Error){
            	trace("this is a bug please fix this bug");
            }
        }

        public function refresh_grid_size(value:Number) : void
        {
            map_grid_size = value;
            if (map_object)
            {
                map_object.grid_size = value;
            }
        }

        protected function mouseDown() : void
        {
            return;
        }
    }
}
