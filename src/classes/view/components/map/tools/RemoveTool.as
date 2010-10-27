package classes.view.components.map.tools
{
    import classes.view.components.map.*;
    import flash.events.*;

    public class RemoveTool extends Tool
    {
        public const REMOVE_MAP_OBJECT:String = "removeMapObject";

        public function RemoveTool(value:Object)
        {
            TYPE = "remove";
            super(value);
            action_name = REMOVE_MAP_OBJECT;
        }

        override protected function mouseUp() : void
        {
            if (target as MapObject && target.usable)
            {
                map_object = target;
                dispatchEvent(new Event(CONFIRM_ACTION));
            }
        }

        override public function activate() : void
        {
            set_cursor("remove_cur");
        }

        override public function remove() : void
        {
            if (target as MapObject)
            {
                target.state = "clear";
            }
        }

        override public function action_confirmed(... args) : void
        {
            map_objects.removeChild(map_object);
        }

        override protected function mouseOut() : void
        {
            if (target as MapObject)
            {
                target.state = "clear";
            }
        }

        override protected function mouseOver() : void
        {
            set_cursor("remove_cur");
            if (target as MapObject && target.usable)
            {
                target.state = "remove_over";
            }
        }

    }
}
