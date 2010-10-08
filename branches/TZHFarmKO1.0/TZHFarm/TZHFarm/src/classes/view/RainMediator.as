package classes.view
{
    import classes.*;
    import classes.view.components.*;
    import flash.events.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.mediator.*;

    public class RainMediator extends Mediator implements IMediator
    {
        public static const NAME:String = "RainMediator";

        public function RainMediator(value:Object)
        {
            super(NAME, value);
        }

        override public function listNotificationInterests() : Array
        {
            return [ApplicationFacade.START_RAIN, ApplicationFacade.LOAD_FARM];
        }

        protected function get rain() : Rain
        {
            return viewComponent as Rain;
        }

        private function rainStop(event:Event) : void
        {
            return;
        }

        override public function onRegister() : void
        {
            return;
        }

        override public function handleNotification(value:INotification) : void
        {
            switch(value.getName())
            {
                case ApplicationFacade.START_RAIN:
                {
                    rain.start();
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
