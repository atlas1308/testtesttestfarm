package classes.view
{
    import classes.*;
    import classes.model.*;
    import classes.view.components.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;

    public class TooltipMediator extends Mediator implements IMediator
    {
        public static const NAME:String = "TooltipMediator";

        public function TooltipMediator(value:Object)
        {
            super(NAME, value);
        }

        override public function listNotificationInterests() : Array
        {
            return [ApplicationFacade.SHOW_TOOLTIP, ApplicationFacade.HIDE_TOOLTIP];
        }

        protected function get tooltip() : Tooltip
        {
            return viewComponent as Tooltip;
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
                case ApplicationFacade.SHOW_TOOLTIP:
                {
                    this.tooltip.visible = true;
                    this.tooltip.setText(value.getBody() as String);
                    break;
                }
                case ApplicationFacade.HIDE_TOOLTIP:
                {
                    tooltip.visible = false;
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
