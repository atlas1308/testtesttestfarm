package classes.view.components.map.tools
{
    import classes.view.components.map.*;
    
    import flash.events.*;

    public class AddMapObjectTool extends Tool
    {
        public const ADD_MAP_OBJECT:String = "addMapObject";

        public function AddMapObjectTool(value:Object)
        {
            TYPE = "add_MO";
            super(value);
            action_name = ADD_MAP_OBJECT;
        }

        override public function activate() : void
        {
            super.activate();
            clear();
            switch(data.type)
            {
                case "buildings":
                case "special_events":
                case "animals":
                case "gear":
                {
                    switch(data.kind)
                    {
                        case "cow":
                        {
                            map_object = new Cow(data);
                            break;
                        }
                        case "ketchup":
                        {
                            map_object = new Ketchup(data);
                            break;
                        }
                        case "mill":
                        {
                            map_object = new Mill(data);
                            break;
                        }
                        case "cheese":
                        {
                            map_object = new Cheese(data);
                            break;
                        }
                        case "chicken_coop":
                        {
                            map_object = new ChickenCoop(data);
                            break;
                        }
                        case "rabbit":
                        {
                            map_object = new Rabbit(data);
                            break;
                        }
                        case "sheep":
                        {
                            map_object = new Sheep(data);
                            break;
                        }
                        case "fertilizer":
                        {
                            map_object = new Fertilizer(data);
                            break;
                        }
                        case "wine":
                        {
                            map_object = new WineMachine(data);
                            break;
                        }
                        case "hive":
                        {
                            map_object = new Hive(data);
                            break;
                        }
                        case "jam":
                        {
                            map_object = new JamMachine(data);
                            break;
                        }
                        case "bread":
                        {
                            map_object = new BreadMachine(data);
                            break;
                        }
                        case "textile":
                        {
                            map_object = new TextileMachine(data);
                            break;
                        }
                        case "greenhouse":
                        {
                            map_object = new Greenhouse(data);
                            break;
                        }
                        case "multi_mill":
                        {
                            map_object = new MultiMill(data);
                            break;
                        }
                        case "house":
                        {
                            map_object = new Decoration(data);
                            break;
                        }
                        case "water_well":
                        {
                            map_object = new WaterWell(data);
                            break;
                        }
                        case "packing":
                        {
                            map_object = new PackingMachine(data);
                            break;
                        }
                        default:
                        {
                            map_object = new MapObject(data);
                            break;
                        }
                    }
                    map_object.enabled = false;
                    break;
                }
                case "trees":
                {
                    map_object = new Tree(data);
                    break;
                }
                case "decorations":
                {
                    switch(data.kind)
                    {
                        case "christmas_tree":
                        {
                            map_object = new ChristmasTree(data);
                            break;
                        }
                        case "fence":
                        {
                            map_object = new Fence(data);
                            break;
                        }
                        case "animation":
                        {
                        	map_object = new AnimationDecoration(data);
                        	break;
                        }
                        default:
                        {
                            map_object = new Decoration(data);
                            break;
                        }
                    }
                    break;
                }
                default:
                {
                    map_object = new MapObject(data);
                    break;
                }
            }
            if (map_object.type == "soil")
            {
                set_cursor("plow_cur");
            }
            map_object.grid_size = map_grid_size;
            map_object.state = "on_add";
            tool_cont.addChild(map_object);
            map_object.snapToGrid(map_size_x, map_size_y, map_top_size);
            if (map_object as Fertilizer)
            {
                Fertilizer(map_object).show_tip();
            }
        }

        override public function remove() : void
        {
            if (last_intersected)
            {
                last_intersected.state = "clear";
            }
        }

        override public function action_confirmed(... args) : void
        {
            action_name = MAP_ADD_OBJECT;
            confirm();
            map_object.enabled = true;
            map_object.state = "clear";
            var type:String = map_object.type;
            if (type != MapObject.MAP_OBJECT_TYPE_SOIL && type != MapObject.MAP_OBJECT_TYPE_DECORATIONS)
            {
                disable();
            }
            map_object = null;
            if(type == MapObject.MAP_OBJECT_TYPE_DECORATIONS){
            	this.activate();
            }else {
            	activated = false;
            	enabled = false; 
            }
        }

        override protected function mouseGridMove() : void
        {
            if (!activated)
            {
                activate();
            }
        }

        override protected function mouseMove() : void
        {
            if (!map_object)
            {
                return;
            }
            if (map_object.type == "soil")
            {
                set_cursor("plow_cur");
            }
            map_object.state = "on_add";
            map_object.snapToGrid(map_size_x, map_size_y, map_top_size);
            object_intersect(map_object);
        }

        override protected function mouseUp() : void
        {
            if (!map_object)
            {
                return;
            }
            if (!object_intersect(map_object))
            {
                if (map_object as Fertilizer)
                {
                    Fertilizer(map_object).hide_tip();
                }
                action_name = ADD_MAP_OBJECT;
                dispatchEvent(new Event(CONFIRM_ACTION));
                action_confirmed();
            }
        }

    }
}
