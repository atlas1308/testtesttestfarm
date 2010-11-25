package classes.controller
{
	import classes.model.AppDataProxy;
	import classes.model.TransactionBody;
	import classes.model.TransactionProxy;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class GetMessageCommand extends SimpleCommand implements ICommand
	{
		public function GetMessageCommand() {
		}

        override public function execute(value:INotification) : void
        {
            var proxy:TransactionProxy = facade.retrieveProxy(TransactionProxy.NAME) as TransactionProxy;
            var appDataProxy:AppDataProxy = facade.retrieveProxy(AppDataProxy.NAME) as AppDataProxy;
            var body:TransactionBody = new TransactionBody("get_message", "get_message");
            body.add_parameter("id",appDataProxy.currentUser.uid);
            proxy.add(body);
        }
	}
}