package classes.view
{
    import classes.*;
    import classes.utils.*;
    import classes.view.components.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;

    public class OverlayMediator extends Mediator implements IMediator
    {
        public static const NAME:String = "OverlayMediator";

        public function OverlayMediator(value:Object)
        {
            super(NAME, value);
        }

        override public function listNotificationInterests() : Array
        {
            return [ApplicationFacade.SHOW_OVERLAY, ApplicationFacade.HIDE_OVERLAY, ApplicationFacade.STAGE_RESIZE];
        }

        override public function onRegister() : void
        {
            return;
        }

        override public function handleNotification(value:INotification) : void
        {
            switch(value.getName())
            {
                case ApplicationFacade.SHOW_OVERLAY:
                {
                    Cursor.hide();
                    overlay.draw(value.getBody() as Boolean);
                    break;
                }
                case ApplicationFacade.HIDE_OVERLAY:
                {
                    overlay.hide();
                    break;
                }
                case ApplicationFacade.STAGE_RESIZE:
                {
                    overlay.refresh();
                    break;
                }
                default:
                {
                    break;
                }
            }
        }

        protected function get overlay() : Overlay
        {
            return viewComponent as Overlay;
        }

    }
}
