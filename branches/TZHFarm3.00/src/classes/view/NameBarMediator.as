package classes.view
{
    import classes.*;
    import classes.model.*;
    import classes.view.components.*;
    import flash.events.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;

    public class NameBarMediator extends Mediator implements IMediator
    {
        public static const NAME:String = "NameBarMediator";

        public function NameBarMediator(value:Object)
        {
            super(NAME, value);
        }

        override public function listNotificationInterests() : Array
        {
            return [ApplicationFacade.UPDATE_OBJECTS, ApplicationFacade.SHOW_FARM, ApplicationFacade.BACK_TO_MY_RANCH, ApplicationFacade.ACTIVATE_SNAPSHOT_MODE, ApplicationFacade.DEACTIVATE_SNAPSHOT_MODE];
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
            name_bar.addEventListener(name_bar.SHOW_TOOLTIP, showTooltip);
            name_bar.addEventListener(name_bar.HIDE_TOOLTIP, hideTooltip);
        }

        override public function handleNotification(value:INotification) : void
        {
            var body:Object = null;
            switch(value.getName())
            {
                case ApplicationFacade.UPDATE_OBJECTS:
                {
                    body = value.getBody();
                    if (body.name)
                    {
                        this.name_bar.update(app_data.user_name);
                    }
                    break;
                }
                case ApplicationFacade.SHOW_FARM:
                {
                    this.name_bar.update(app_data.friend_name, true);
                    break;
                }
                case ApplicationFacade.BACK_TO_MY_RANCH:
                {
                    this.name_bar.update(app_data.user_name);
                    break;
                }
                case ApplicationFacade.ACTIVATE_SNAPSHOT_MODE:
                {
                    this.name_bar.visible = false;
                    break;
                }
                case ApplicationFacade.DEACTIVATE_SNAPSHOT_MODE:
                {
                    this.name_bar.visible = true;
                    break;
                }
                default:
                {
                    break;
                }
            }
        }

        protected function get name_bar() : NameBar
        {
            return viewComponent as NameBar;
        }

    }
}
