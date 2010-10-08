package classes.controller
{
    import classes.model.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.command.*;

    public class UseFacebookDataCommand extends SimpleCommand implements ICommand
    {

        public function UseFacebookDataCommand()
        {
            return;
        }

        override public function execute(value:INotification) : void
        {
            var appDataProxy:AppDataProxy = facade.retrieveProxy(AppDataProxy.NAME) as AppDataProxy;
            appDataProxy.set_fb_data(value.getBody());
        }

    }
}
