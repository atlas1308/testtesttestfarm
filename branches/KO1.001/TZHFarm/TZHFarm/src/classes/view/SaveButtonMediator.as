package classes.view
{
    import classes.*;
    import classes.model.*;
    import classes.view.components.*;
    import flash.events.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;

    public class SaveButtonMediator extends Mediator implements IMediator
    {
        public static const NAME:String = "SaveButtonMediator";

        public function SaveButtonMediator(param1:Object)
        {
            super(NAME, param1);
            return;
        }

        override public function listNotificationInterests() : Array
        {
            return [ApplicationFacade.ENABLE_SAVE_BUTTON, ApplicationFacade.DISABLE_SAVE_BUTTON, ApplicationFacade.ACTIVATE_SNAPSHOT_MODE, ApplicationFacade.DEACTIVATE_SNAPSHOT_MODE];
        }

        private function saveClicked(event:Event) : void
        {
            sendNotification(ApplicationFacade.SAVE_DATA);
            return;
        }

        protected function get button() : SaveButton
        {
            return viewComponent as SaveButton;
        }

        protected function get app_data() : AppDataProxy
        {
            return facade.retrieveProxy(AppDataProxy.NAME) as AppDataProxy;
        }

        override public function onRegister() : void
        {
            button.addEventListener(button.SAVE_CLICKED, saveClicked);
            return;
        }

        override public function handleNotification(value:INotification) : void
        {
            switch(value.getName())
            {
                case ApplicationFacade.ENABLE_SAVE_BUTTON:
                {
                    button.show(value.getBody() as Boolean);
                    break;
                }
                case ApplicationFacade.DISABLE_SAVE_BUTTON:
                {
                    button.hide();
                    break;
                }
                case ApplicationFacade.ACTIVATE_SNAPSHOT_MODE:
                {
                    button.visible = false;
                    break;
                }
                case ApplicationFacade.DEACTIVATE_SNAPSHOT_MODE:
                {
                    button.visible = true;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }

    }
}
