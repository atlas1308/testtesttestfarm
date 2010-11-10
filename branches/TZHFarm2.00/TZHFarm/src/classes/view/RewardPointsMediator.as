package classes.view
{
    import classes.*;
    import classes.model.*;
    import classes.view.components.*;
    import flash.events.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;

    public class RewardPointsMediator extends Mediator implements IMediator
    {
        public static const NAME:String = "RewardPointsMediator";

        public function RewardPointsMediator(value:Object)
        {
            super(NAME, value);
        }

        override public function listNotificationInterests() : Array
        {
            return [ApplicationFacade.UPDATE_OBJECTS, ApplicationFacade.ACTIVATE_SNAPSHOT_MODE, ApplicationFacade.DEACTIVATE_SNAPSHOT_MODE];
        }

        private function hideTooltip(event:Event) : void
        {
            sendNotification(ApplicationFacade.HIDE_TOOLTIP);
        }

        private function showTooltip(event:Event) : void
        {
            sendNotification(ApplicationFacade.SHOW_TOOLTIP, event.target.message);
        }

        protected function get app_data() : AppDataProxy
        {
            return facade.retrieveProxy(AppDataProxy.NAME) as AppDataProxy;
        }

        override public function onRegister() : void
        {
            rp.addEventListener(rp.ADD_RANCH_CASH, addRanchCash);
            rp.addEventListener(rp.SHOW_TOOLTIP, showTooltip);
            rp.addEventListener(rp.HIDE_TOOLTIP, hideTooltip);
        }

        private function addRanchCash(event:Event) : void
        {
            sendNotification(ApplicationFacade.SHOW_ADD_CASH_POPUP);
        }

        override public function handleNotification(value:INotification) : void
        {
            var body:Object = null;
            switch(value.getName())
            {
                case ApplicationFacade.UPDATE_OBJECTS:
                {
                    body = value.getBody();
                    if (body.reward_points)
                    {
                        rp.update(app_data.reward_points);
                    }
                    break;
                }
                case ApplicationFacade.ACTIVATE_SNAPSHOT_MODE:
                {
                    rp.visible = false;
                    break;
                }
                case ApplicationFacade.DEACTIVATE_SNAPSHOT_MODE:
                {
                    rp.visible = true;
                    break;
                }
                default:
                {
                    break;
                }
            }
        }

        protected function get rp() : RewardPoints
        {
            return viewComponent as RewardPoints;
        }

    }
}
