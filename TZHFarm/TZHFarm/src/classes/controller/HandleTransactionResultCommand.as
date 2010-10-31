package classes.controller
{
    import classes.*;
    import classes.model.*;
    import classes.model.err.*;
    import classes.utils.*;
    
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.command.*;
    
    import tzh.core.SystemTimer;

    public class HandleTransactionResultCommand extends SimpleCommand implements ICommand
    {

        public function HandleTransactionResultCommand()
        {
            return;
        }

        override public function execute(value:INotification) : void
        {
            var appDataProxy:AppDataProxy = facade.retrieveProxy(AppDataProxy.NAME) as AppDataProxy;
            var transactionResult:TransactionResult = value.getBody() as TransactionResult;
            if(!transactionResult){
            	 appDataProxy.show_refresh_page_popup(Err.CALL_DELAY, Err.CALL_DELAY_CODE);
            	 return;
            }
            switch(transactionResult.channel)
            {
                case "retrieve":
                {
                    if (transactionResult.is_ok())
                    {
                    	var time:Number = transactionResult.data.time;
                        Algo.set_time(time);
                        SystemTimer.getInstance().serverTime = time;
                        appDataProxy.init(transactionResult.data.config, transactionResult.data.data);
                    }
                    else
                    {
                        appDataProxy.show_refresh_page_popup(Err.CALL_DELAY, Err.CALL_DELAY_CODE);
                    }
                    break;
                }
                case "load_neighbors":
                {
                    appDataProxy.neighbors_loaded(transactionResult.data);
                    break;
                }
                case "post_published":
                {
                    break;
                }
                case "purchase_gift":
                {
                    //sendNotification(ApplicationFacade.SHOW_POPUP, appDataProxy.get_gift_sent_confirmation_data());
                    break;
                }
                default:
                {
                    appDataProxy.handle_response(transactionResult.data, transactionResult.channel);
                    break;
                }
            }
        }

    }
}
