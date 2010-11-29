package classes.controller
{
    import classes.*;
    import classes.model.*;
    import classes.model.transactions.*;
    import classes.view.SaveButtonMediator;
    import classes.view.components.SaveButton;
    
    import flash.events.Event;
    
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.command.*;

    public class LoadFarmCommand extends SimpleCommand implements ICommand
    {

        public function LoadFarmCommand()
        {
        }
		
		private var user_id:String;// 用户id
		
		private var transactionProxy:TransactionProxy
		
		/**
		 * 这里的操作要特别注意
		 * 因为有的时候用户操作过快,有些请求还没有加到队列里面
		 * 又开始去请求其它的用户,结果后台先返回请求的数据,之后才返回队列成功是否
		 * 造成了用户的数据没有正常的刷新
		 * 这样我们就得做一个处理
		 * 当右上角的的保存按纽,如果可以再点击的话,说明还有东西正在执行　
		 * 如果TransactionManager里的队列如果还有数据的话,说明也是可以保存东西的
		 * 所以监听事件,当结束后,还要去判断是否还有队列
		 */ 
        override public function execute(value:INotification) : void
        {
            sendNotification(ApplicationFacade.SHOW_OVERLAY, true);
            user_id = value.getBody().toString();
            var appDataProxy:AppDataProxy = facade.retrieveProxy(AppDataProxy.NAME) as AppDataProxy;
            appDataProxy.messages = [];
            appDataProxy.cancel_help_popup();
            appDataProxy.clear_process_queue();
            transactionProxy = facade.retrieveProxy(TransactionProxy.NAME) as TransactionProxy;
            var manager:TransactionManager = transactionProxy.batchManager;
            if(manager.is_busy || manager.hasQueue()){// 如果显示的话，则肯定正在执行,如果有队列，把这些队列都立即执行掉
            	manager.addEventListener(manager.ON_IDLE,idleHandler);// 服务器是空闲的状态
            	manager.save();
            }else {
            	this.idleHandler();
            }
        }
        
        private function idleHandler(event:Event = null):void {
        	var manager:TransactionManager = transactionProxy.batchManager;
        	if(!manager.hasQueue()){
        		manager.removeEventListener(manager.ON_IDLE,idleHandler);// 先移除掉，后再添加上
        		this.call();
        	}else {
        		manager.removeEventListener(manager.ON_IDLE,idleHandler);// 先移除掉，后再添加上
        		manager.addEventListener(manager.ON_IDLE,idleHandler);// 服务器是空闲的状态
        		manager.save()
        	}
        }
        
        private function call():void {
        	transactionProxy = facade.retrieveProxy(TransactionProxy.NAME) as TransactionProxy;
            transactionProxy.add(new LoadFarmCall(user_id));
            
        }
    }
}
