package classes.view
{
    import classes.*;
    import classes.view.components.*;
    import org.puremvc.as3.multicore.interfaces.*;

    public class FriendFarmMediator extends MapMediator
    {

        public function FriendFarmMediator(value:Object)
        {
            NAME = "FriendFarmMediator";
            super(value);
        }

        override public function listNotificationInterests() : Array
        {
            return [ApplicationFacade.ZOOM_IN, ApplicationFacade.ZOOM_OUT, ApplicationFacade.SHOW_FARM, ApplicationFacade.BACK_TO_MY_RANCH, ApplicationFacade.WATER_PLANTS, ApplicationFacade.PLANTS_WATERED, ApplicationFacade.STAGE_RESIZE, ApplicationFacade.TOGGLE_ALPHA, ApplicationFacade.ACTIVATE_SNAPSHOT_MODE, ApplicationFacade.DEACTIVATE_SNAPSHOT_MODE];
        }

        override protected function can_zoom() : Boolean
        {
            return map_proxy.friend_mode;
        }

        override public function handleNotification(value:INotification) : void
        {
            switch(value.getName())
            {
                case ApplicationFacade.ZOOM_IN:
                case ApplicationFacade.ZOOM_OUT:
                case ApplicationFacade.TOGGLE_ALPHA:
                case ApplicationFacade.ACTIVATE_SNAPSHOT_MODE:
                {
                    super.handleNotification(value);
                    break;
                }
                case ApplicationFacade.DEACTIVATE_SNAPSHOT_MODE:
                {
                    map.set_tool("show_info");
                    break;
                }
                case ApplicationFacade.SHOW_FARM:
                {
                    map.view_mode = Map.FRIEND_VIEW;
                    map.clear();
                    map_proxy.call_garbage_collector();
                    map.set_zoom(map_proxy.get_grid_size());
                    map.update(app_data.get_friend_farm_data());
                    map.set_tool("show_info");
                    map.visible = true;
                    map_proxy.friend_mode = true;
                    break;
                }
                case ApplicationFacade.BACK_TO_MY_RANCH:
                {
                    map.clear();
                    map.visible = false;
                    map_proxy.friend_mode = false;
                    break;
                }
                case ApplicationFacade.PLANTS_WATERED:
                {
                    map.apply_rain(0.5);
                    break;
                }
                case ApplicationFacade.STAGE_RESIZE:
                {
                    if (map_proxy.friend_mode)
                    {
                        map.refresh_viewport();
                        map.center_map();
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
        }

    }
}
