package classes.view
{
    import classes.*;
    import classes.model.*;
    import classes.view.components.*;
    import flash.events.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;

    public class GiftBoxMediator extends Mediator implements IMediator
    {
        public static const NAME:String = "GiftBoxMediator";

        public function GiftBoxMediator(value:Object)
        {
            super(NAME, value);
        }

        override public function listNotificationInterests() : Array
        {
            return [ApplicationFacade.ACTIVATE_SNAPSHOT_MODE, ApplicationFacade.DEACTIVATE_SNAPSHOT_MODE, ApplicationFacade.SHOW_GIFT_BOX, ApplicationFacade.HIDE_GIFT_BOX];
        }

        protected function get app_data() : AppDataProxy
        {
            return facade.retrieveProxy(AppDataProxy.NAME) as AppDataProxy;
        }

        override public function onRegister() : void
        {
            box.addEventListener(MouseEvent.CLICK, boxClicked);
            box.visible = false;
        }

        override public function handleNotification(value:INotification) : void
        {
            switch(value.getName())
            {
                case ApplicationFacade.ACTIVATE_SNAPSHOT_MODE:
                {
                    box.visible = false;
                    break;
                }
                case ApplicationFacade.DEACTIVATE_SNAPSHOT_MODE:
                {
                    box.visible = true;
                    break;
                }
                case ApplicationFacade.SHOW_GIFT_BOX:
                {
                    box.visible = true;
                    break;
                }
                case ApplicationFacade.HIDE_GIFT_BOX:
                {
                    box.visible = false;
                    break;
                }
                default:
                {
                    break;
                }
            }
        }

        private function boxClicked(event:MouseEvent) : void
        {
            sendNotification(ApplicationFacade.SHOW_POPUP, {message:"Would you like to send FREE gifts to your friends now? They are likely to return the favor!", type:PopupTypes.SHOW_GIFTS_POPUP});
        }

        protected function get box() : GiftBox
        {
            return viewComponent as GiftBox;
        }

    }
}
