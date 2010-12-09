package classes.controller
{
    import classes.model.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.command.*;

    public class SaveDataCommand extends SimpleCommand implements ICommand
    {

        public function SaveDataCommand()
        {
        }

        override public function execute(value:INotification) : void
        {
            var transactionProxy:TransactionProxy = facade.retrieveProxy(TransactionProxy.NAME) as TransactionProxy;
            transactionProxy.save();
        }

    }
}
