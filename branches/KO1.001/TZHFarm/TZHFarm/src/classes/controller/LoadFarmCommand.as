package classes.controller
{
    import classes.*;
    import classes.model.*;
    import classes.model.transactions.*;
    
    import flash.display.Loader;
    
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.command.*;

    public class LoadFarmCommand extends SimpleCommand implements ICommand
    {

        public function LoadFarmCommand()
        {
            return;
        }

        override public function execute(value:INotification) : void
        {
            sendNotification(ApplicationFacade.SHOW_OVERLAY, true);
            var transactionProxy:TransactionProxy = facade.retrieveProxy(TransactionProxy.NAME) as TransactionProxy;
            var appDataProxy:AppDataProxy = facade.retrieveProxy(AppDataProxy.NAME) as AppDataProxy;
            appDataProxy.cancel_help_popup();
            transactionProxy.add(new LoadFarmCall(value.getBody() as Number));
        }
    }
}
