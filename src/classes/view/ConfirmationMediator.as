package classes.view
{
    import classes.*;
    import classes.model.*;
    import classes.view.components.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;

    public class ConfirmationMediator extends Mediator implements IMediator
    {
        public static const NAME:String = "ConfirmationMediator";

        public function ConfirmationMediator(value:Object)
        {
            super(NAME, value);
        }

        override public function listNotificationInterests() : Array
        {
            return [ApplicationFacade.DISPLAY_CONFIRMATION];
        }

        protected function get app_data() : AppDataProxy
        {
            return facade.retrieveProxy(AppDataProxy.NAME) as AppDataProxy;
        }

        override public function onRegister() : void
        {
            return;
        }

        override public function handleNotification(value:INotification) : void
        {
            switch(value.getName())
            {
                case ApplicationFacade.DISPLAY_CONFIRMATION:
                {
                    confirm.show(value.getBody());
                    break;
                }
                default:
                {
                    break;
                }
            }
        }

        protected function get confirm() : ConfirmationContainer
        {
            return viewComponent as ConfirmationContainer;
        }

    }
}
