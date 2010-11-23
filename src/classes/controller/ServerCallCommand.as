package classes.controller
{
    import classes.*;
    import classes.model.*;
    import classes.model.transactions.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.command.*;

    public class ServerCallCommand extends SimpleCommand implements ICommand
    {

        public function ServerCallCommand()
        {
            return;
        }

        override public function execute(value:INotification) : void
        {
            var body:Object = null;
            var transactionProxy:TransactionProxy = facade.retrieveProxy(TransactionProxy.NAME) as TransactionProxy;
            var appDataProxy:AppDataProxy = facade.retrieveProxy(AppDataProxy.NAME) as AppDataProxy;
            switch(value.getName())
            {
                case ApplicationFacade.LOAD_NEIGHBORS:
                {
                    transactionProxy.add(new LoadNeighborsCall(value.getBody() as Array));
                    break;
                }
                case ApplicationFacade.POST_PUBLISHED:
                {
                    body = value.getBody();
                    Log.add("POST_PUBLISHED " + body.target);
                    appDataProxy.post_published(body.subtype, body.target);
                    transactionProxy.add(new PostPublishedCall("stream", body.tag, body.subtype, body.story_id, body.target));
                    break;
                }
                case ApplicationFacade.SEND_GIFT:
                {
                    if (appDataProxy.send_gift(value.getBody()))
                    {
                        transactionProxy.add(new SendGiftCall(value.getBody()));
                    }
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
