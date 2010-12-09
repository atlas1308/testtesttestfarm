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
                    	var time:Number = transactionResult.data.time;// 去掉这个延迟;
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
                case "purchase_gift":
                {
                    //sendNotification(ApplicationFacade.SHOW_POPUP, appDataProxy.get_gift_sent_confirmation_data());
                    break;
                }
                case "get_message":{
                	var list:Array = transactionResult.data.messages;
                	list.sortOn("msgtime",Array.DESCENDING | Array.NUMERIC);//  这里修改了一下
                	appDataProxy.messages = list;// set 数据
                	sendNotification(ApplicationFacade.UPDATE_NEWS_PANEL);
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
