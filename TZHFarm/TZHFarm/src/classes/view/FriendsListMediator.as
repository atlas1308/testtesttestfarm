package classes.view
{
    import classes.*;
    import classes.model.*;
    import classes.view.components.*;
    
    import flash.events.*;
    
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;
    
    import tzh.core.JSDataManager;

    public class FriendsListMediator extends Mediator implements IMediator
    {
        public static const NAME:String = "FriendsListMediator";

        public function FriendsListMediator(value:Object)
        {
            super(NAME, value);
        }

        override public function listNotificationInterests() : Array
        {
            return [ApplicationFacade.UPDATE_OBJECTS, ApplicationFacade.BACK_TO_MY_RANCH, ApplicationFacade.NEIGHBORS_LOADED, ApplicationFacade.ACTIVATE_SNAPSHOT_MODE, ApplicationFacade.DEACTIVATE_SNAPSHOT_MODE];
        }

        protected function get app_data() : AppDataProxy
        {
            return facade.retrieveProxy(AppDataProxy.NAME) as AppDataProxy;
        }

        override public function onRegister() : void
        {
            friends_list.addEventListener(friends_list.FRIEND_CLICKED, showFriendFarm);
            friends_list.addEventListener(friends_list.ADD_NEIGHBOR, addNeighbor);
            friends_list.addEventListener(friends_list.LOAD_NEIGHBORS, loadNeighbors);
        }

        override public function handleNotification(showFriendFarm:INotification) : void
        {
            var body:Object = null;
            switch(showFriendFarm.getName())
            {
                case ApplicationFacade.UPDATE_OBJECTS:
                {
                    body = showFriendFarm.getBody();
                    if (body.neighbors)
                    {
                        Log.add("update friends");
                        friends_list.update(app_data.get_neighbors_data());// 在这里更新friends
                    }
                    break;
                }
                case ApplicationFacade.BACK_TO_MY_RANCH:
                {
                    friends_list.clear_visited_friend();
                    break;
                }
                case ApplicationFacade.NEIGHBORS_LOADED:
                {
                    friends_list.update_friends(showFriendFarm.getBody() as Array);
                    break;
                }
                case ApplicationFacade.ACTIVATE_SNAPSHOT_MODE:
                {
                    friends_list.visible = false;
                    break;
                }
                case ApplicationFacade.DEACTIVATE_SNAPSHOT_MODE:
                {
                    friends_list.visible = true;
                    break;
                }
                default:
                {
                    break;
                }
            }
        }

        protected function get friends_list() : FriendsList
        {
            return viewComponent as FriendsList;
        }

        private function showFriendFarm(event:Event) : void
        {
            sendNotification(ApplicationFacade.LOAD_FARM, event.target.uid);
        }

        private function addNeighbor(event:Event) : void
        {
            JSDataManager.showInviteFriendPage();
        }

        private function loadNeighbors(event:Event) : void
        {
            sendNotification(ApplicationFacade.LOAD_NEIGHBORS, event.target.friends_to_load);
        }

    }
}
