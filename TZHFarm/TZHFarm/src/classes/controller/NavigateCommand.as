package classes.controller
{
    import classes.model.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.command.*;

    public class NavigateCommand extends SimpleCommand implements ICommand
    {

        public function NavigateCommand()
        {
            return;
        }

        override public function execute(value:INotification) : void
        {
            var appDataProxy:AppDataProxy = facade.retrieveProxy(AppDataProxy.NAME) as AppDataProxy;
            appDataProxy.navigate_to(value.getBody() as String);
        }

    }
}
