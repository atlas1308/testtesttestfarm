package classes.view.components.map.tools
{
    import classes.view.components.*;
    import classes.view.components.map.tools.collect_tools.*;
    import flash.events.*;

    public class MultiTool extends Tool
    {
        public const FERTILIZE:String = "fertilize";
        private var subtool:Subtool;
        public const COLLECT_PRODUCT:String = "collectProduct";
        private var last_tool_type:String;
        public const FEED_MAP_OBJECT:String = "feedMapObject";
        private var last_needed_tool:Subtool;
        public const SHOW_SHOP_AND_ADD_PLANT:String = "showShopAndAddPlant";

        public function MultiTool(param1:Object)
        {
            super(param1);
            TYPE = "collect";
            action_name = COLLECT_PRODUCT;
            return;
        }

        private function init_subtool(a:Subtool) : void
        {
            a.init(tool_cont, map_objects);
            a.set_bounds(map_size_x, map_size_y, map_top_size);
            a.refresh_grid_size(map_grid_size);
            a.activate();
            return;
        }

        private function subtool_disabled(event:Event) : void
        {
            subtool.removeEventListener(subtool.ON_DISABLE, subtool_disabled);
            subtool.removeEventListener(subtool.CONFIRM_ACTION, confirmSubtoolAction);
            subtool = null;
            return;
        }

        override public function remove() : void
        {
            current_subtool.remove();
            return;
        }

        private function get_subtool_by_target(value:Object) : Subtool
        {
            var tool:* = new Subtool();
            if (!value)
            {
                return tool;
            }
            switch(value.type)
            {
                case "animals":
                {
                    switch(value.kind)
                    {
                        case "cow":
                        {
                            tool = new CowTool();
                            break;
                        }
                        case "rabbit":
                        {
                            tool = new RabbitTool();
                            break;
                        }
                        case "sheep":
                        {
                            tool = new SheepTool();
                            break;
                        }
                        case "hive":
                        {
                            tool = new HiveTool();
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    break;
                }
                case "seeds":
                {
                    tool = new HarvestTool();
                    break;
                }
                case "soil":
                {
                    tool = new PlantTool();
                    break;
                }
                case "gear":
                {
                    switch(value.kind)
                    {
                        case "ketchup":
                        {
                            tool = new KetchupTool();
                            break;
                        }
                        case "cheese":
                        {
                            tool = new CheeseTool();
                            break;
                        }
                        case "chicken_coop":
                        {
                            tool = new ChickenCoopTool();
                            break;
                        }
                        case "wine":
                        {
                            tool = new WineMachineTool();
                            break;
                        }
                        case "jam":
                        {
                            tool = new JamMachineTool();
                            break;
                        }
                        case "bread":
                        {
                            tool = new BreadMachineTool();
                            break;
                        }
                        case "textile":
                        {
                            tool = new TextileMachineTool();
                            break;
                        }
                        case "packing":
                        {
                            tool = new PackingMachineTool();
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    break;
                }
                case "buildings":
                {
                    switch(value.kind)
                    {
                        case "mill":
                        {
                            tool = new MillTool();
                            break;
                        }
                        case "multi_mill":
                        {
                            tool = new MultiMillTool();
                            break;
                        }
                        case "greenhouse":
                        {
                            tool = new GreenhouseTool();
                            break;
                        }
                        case "house":
                        {
                            tool = new DecorationTool();
                            break;
                        }
                        case "water_well":
                        {
                            tool = new WaterWellTool();
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    break;
                }
                case "special_events":
                {
                    switch(value.kind)
                    {
                        case "fertilizer":
                        {
                            tool = new FertilizerTool();
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    break;
                }
                case "trees":
                {
                    tool = new TreeTool();
                    break;
                }
                case "decorations":
                {
                    switch(value.kind)
                    {
                        case "christmas_tree":
                        {
                            tool = new ChristmasTreeTool();
                            break;
                        }
                        default:
                        {
                            tool = new DecorationTool();
                            break;
                        }
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return tool;
        }

        private function confirmSubtoolAction(event:Event) : void
        {
            action_name = event.target.action;
            dispatchEvent(new Event(CONFIRM_ACTION));
        }

        private function get current_subtool() : Subtool
        {
            if (subtool)
            {
                return subtool;
            }
            return needed_tool;
        }

        override protected function mouseMove() : void
        {
            return;
        }

        override protected function mouseOver() : void
        {
            return;
        }

        override public function action_confirmed(... args) : void
        {
            current_subtool.action_confirmed(args[0]);
        }

        protected function get needed_tool() : Subtool
        {
            if (!target)
            {
                return new Subtool();
            }
            if (last_tool_type == target.type + target.kind)
            {
                return last_needed_tool;
            }
            last_tool_type = target.type + target.kind;
            last_needed_tool = get_subtool_by_target(target);
            init_subtool(last_needed_tool);
            return last_needed_tool;
        }

        override public function mouse(state:String, target:Object) : void
        {
            super.mouse(state, target);
            if (subtool)
            {
                subtool.mouse(state, target);
                if (subtool && subtool.allow())
                {
                    needed_tool.mouse(state, target);
                    subtool.remove();
                }
                else if (!subtool)
                {
                    current_subtool.mouse(state, target);
                }
            }
            else
            {
                current_subtool.mouse(state, target);
            }
        }

        override protected function mouseUp() : void
        {
            set_subtool();
        }

        override protected function mouseOut() : void
        {
            return;
        }

        override public function activate() : void
        {
            super.activate();
            if (data && data.subtool)
            {
                set_subtool(get_subtool_by_target(data.subtool));
            }
        }

        override public function refresh_grid_size(value:Number) : void
        {
            super.refresh_grid_size(value);
            map_grid_size = value;
            if (map_object)
            {
                map_object.grid_size = value;
            }
            current_subtool.refresh_grid_size(value);
        }

        override public function get_event_data() : Object
        {
            return current_subtool.get_event_data();
        }

        private function set_subtool(value:Subtool = null) : void
        {
            var tool:* = subtool;
            if (!value)
            {
                if (subtool && !subtool.allow())
                {
                    return;
                }
                if (needed_tool.TYPE == "subtool")
                {
                    return;
                }
                if (!needed_tool.usable())
                {
                    return;
                }
                subtool = needed_tool;
            }
            else
            {
                subtool = value;
                init_subtool(subtool);
            }
            if (tool && tool.TYPE != subtool.TYPE)
            {
                tool.removeEventListener(tool.ON_DISABLE, subtool_disabled);
                tool.removeEventListener(tool.CONFIRM_ACTION, confirmSubtoolAction);
                tool.remove();
            }
            subtool.addEventListener(subtool.ON_DISABLE, subtool_disabled);
            subtool.addEventListener(subtool.CONFIRM_ACTION, confirmSubtoolAction);
            confirm(Map.DEACTIVATE_MULTI_TOOL);
        }

    }
}
