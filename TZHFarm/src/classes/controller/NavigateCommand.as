package classes.controller
{
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	
	/**
	 * 跳转页面,充值的时候会用到
	 */ 
    public class NavigateCommand extends SimpleCommand implements ICommand
    {

        public function NavigateCommand()
        {
            return;
        }

        override public function execute(value:INotification) : void
        {
        }

    }
}
