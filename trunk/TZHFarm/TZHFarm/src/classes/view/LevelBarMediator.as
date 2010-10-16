package classes.view
{
    import classes.*;
    import classes.model.*;
    import classes.view.components.*;
    import flash.events.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;

    public class LevelBarMediator extends Mediator implements IMediator
    {
        public static const NAME:String = "LevelBarMediator";

        public function LevelBarMediator(value:Object)
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
            level_bar.addEventListener(level_bar.SHOW_TOOLTIP, showTooltip);
            level_bar.addEventListener(level_bar.HIDE_TOOLTIP, hideTooltip);
        }

        override public function handleNotification(value:INotification) : void
        {
            var body:Object = null;
            switch(value.getName())
            {
                case ApplicationFacade.UPDATE_OBJECTS:
                {
                    body = value.getBody();
                    if (body.level || body.experience)
                    {
                        this.level_bar.update(app_data.get_level_data());
                    }
                    break;
                }
                case ApplicationFacade.ACTIVATE_SNAPSHOT_MODE:
                {
                    this.level_bar.visible = false;
                    break;
                }
                case ApplicationFacade.DEACTIVATE_SNAPSHOT_MODE:
                {
                    this.level_bar.visible = true;
                    break;
                }
                default:
                {
                    break;
                }
            }
        }

        protected function get level_bar() : LevelBar
        {
            return viewComponent as LevelBar;
        }

    }
}
