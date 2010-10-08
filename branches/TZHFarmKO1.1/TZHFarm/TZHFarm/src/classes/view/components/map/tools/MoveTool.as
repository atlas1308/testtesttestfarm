package classes.view.components.map.tools
{
    import classes.view.components.map.*;
    
    import mx.resources.ResourceManager;

    public class MoveTool extends Tool
    {
        private var flip_failed:Boolean = false;
        public const MOVE_MAP_OBJECT:String = "moveMapObject";
        public const FLIP_MAP_OBJECT:String = "flipMapObject";
        private var object_moved:Boolean = false;

        public function MoveTool(value:Object)
        {
            TYPE = "move";
            super(value);
            action_name = MOVE_MAP_OBJECT;
        }

        override public function remove() : void
        {
            if (object_moved)
            {
                map_object.grid_x = map_object.map_x;
                map_object.grid_y = map_object.map_y;
                map_objects.addChild(map_object);
                map_object.state = "clear";
                if (last_intersected)
                {
                    last_intersected.state = "clear";
                }
            }
            else if (target as MapObject)
            {
                target.state = "clear";
            }
            if (flip_failed)
            {
                map_object.flip();
                flip_failed = false;
            }
            return;
        }

        override protected function mouseUp() : void
        {
            if (!object_moved)
            {
                if (!(target as MapObject) || !target.usable)
                {
                    return;
                }
                map_object = target;
                if (map_object.rotate_btn_clicked() && map_object.flipable)
                {
                    map_object.flip();
                    map_object.state = "move_over";
                    tool_cont.addChild(map_object);
                    object_moved = true;
                    map_object.snapToGrid(map_size_x, map_size_y, map_top_size);
                    flip_failed = true;
                }
                else
                {
                    object_moved = true;
                    tool_cont.addChild(target);
                    map_object = target;
                    map_object.state = "on_move";
                }
            }
            else if (!object_intersect(map_object))
            {
                map_objects.addChild(map_object);
                map_object.state = "clear";
                map_object.changed();
                action_name = MOVE_MAP_OBJECT;
                confirm();
            }
            else if (map_object as Tree && object_intersected as Tree)
            {
                action_name = SHOW_CONFIRM_ERROR;
                error_message = ResourceManager.getInstance().getString("message","too_close_to_another_tree_message");
                confirm();
            }
        }

        override protected function mouseOut() : void
        {
            if (target as MapObject)
            {
                target.state = "clear";
            }
        }

        override public function activate() : void
        {
            super.activate();
            flip_failed = false;
            object_moved = false;
            map_object = null;
            set_cursor("move_cur");
        }

        override public function action_confirmed(... args) : void
        {
            activate();
            mouseOver();
        }

        override public function get_event_data() : Object
        {
            switch(action_name)
            {
                case SHOW_CONFIRM_ERROR:
                {
                    return error_message;
                }
                default:
                {
                    return super.get_event_data();
                    break;
                }
            }
        }

        override protected function mouseOver() : void
        {
            set_cursor("move_cur");
            if (target as MapObject && target.usable)
            {
                target.state = "move_over";
            }
        }

        override protected function mouseMove() : void
        {
            if (object_moved)
            {
                map_object.state = "on_move";
                map_object.snapToGrid(this.map_size_x, this.map_size_y, this.map_top_size);
                object_intersect(map_object);
                map_object.changed();
            }
        }

    }
}
