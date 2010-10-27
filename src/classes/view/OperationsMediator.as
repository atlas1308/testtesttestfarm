package classes.view
{
    import classes.*;
    import classes.view.components.*;
    import flash.events.*;
    import org.puremvc.as3.multicore.interfaces.*;

    public class OperationsMediator extends NumericBarMediator
    {

        public function OperationsMediator(value:Object)
        {
            NAME = "OperationsMediator";
            super(value);
        }

        override public function listNotificationInterests() : Array
        {
            return super.listNotificationInterests().concat([ApplicationFacade.ESCAPE_PRESSED, ApplicationFacade.USE_MULTI_TOOL]);
        }

        override public function onRegister() : void
        {
            super.onRegister();
            bar.addEventListener(Operations.AUTOMATION_TOOL_ON, automationToolOn);
            bar.addEventListener(Operations.AUTOMATION_TOOL_OFF, automationToolOff);
        }

        override public function handleNotification(value:INotification) : void
        {
            var body:Object = null;
            switch(value.getName())
            {
                case ApplicationFacade.UPDATE_OBJECTS:
                {
                    body = value.getBody();
                    if (body.operations)// 这里做0的处理
                    {
                        bar.update(app_data.operations);
                    }
                    break;
                }
                case ApplicationFacade.ESCAPE_PRESSED:
                case ApplicationFacade.USE_MULTI_TOOL:
                {
                    Operations(bar).turn_off();
                    break;
                }
                default:
                {
                    super.handleNotification(value);
                    break;
                }
            }
        }

        private function automationToolOn(event:Event) : void
        {
            sendNotification(ApplicationFacade.USE_AUTOMATION_TOOL);
        }

        private function automationToolOff(event:Event) : void
        {
            sendNotification(ApplicationFacade.USE_MULTI_TOOL);
        }

    }
}
