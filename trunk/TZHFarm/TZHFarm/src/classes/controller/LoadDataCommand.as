package classes.controller
{
    import classes.model.*;
    
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.command.*;
    
    import tzh.core.JSDataManager;

    public class LoadDataCommand extends SimpleCommand implements ICommand
    {

        public function LoadDataCommand()
        {
        }

        override public function execute(value:INotification) : void
        {
            Log.add("load data");
            var proxy:TransactionProxy = facade.retrieveProxy(TransactionProxy.NAME) as TransactionProxy;
            var fids:String = JSDataManager.getInstance().fids;
            trace("fids " + fids);
            CONFIG::debug {
            	fids = "11,12,13,14,15,16,17,18,19,20";
            }
            var params:Object = new Object();
            params.fids = fids;
            proxy.add(new TransactionBody("retrieve_data", "retrieve",params));
        }

    }
}
