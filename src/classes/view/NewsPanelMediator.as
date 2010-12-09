package classes.view
{
	import classes.ApplicationFacade;
	import classes.model.AppDataProxy;
	import classes.view.components.messages.NewsPanel;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tzh.UIEvent;

	public class NewsPanelMediator extends Mediator implements IMediator
	{
		public static const MEDIATOR_NAME:String = "NewsPanelMediator";
		public function NewsPanelMediator(viewComponent:Object)
		{
			super(MEDIATOR_NAME, viewComponent);
		}
		
		public function get newsPanel():NewsPanel {
			return viewComponent as NewsPanel;
		}
		
		override public function listNotificationInterests():Array
		{
			return [ApplicationFacade.STAGE_RESIZE,ApplicationFacade.UPDATE_NEWS_PANEL];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var notificationName:String = notification.getName()
			switch(notificationName){
				case ApplicationFacade.STAGE_RESIZE:
					newsPanel.center();
					break;
				case ApplicationFacade.UPDATE_NEWS_PANEL:
					newsPanel.data = app_data.messages;// 改变这个引用
					newsPanel.refresh();
					break;
                default:
                	break;
			}
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			this.newsPanel.addEventListener(UIEvent.SHOW_OVERLAY,showOverlay);
			this.newsPanel.addEventListener(UIEvent.HIDE_OVERLAY,hideOverlay);
			this.newsPanel.addEventListener(UIEvent.ADD_MESSAGE,addMessage);
			this.newsPanel.addEventListener(UIEvent.BUY_ITEM,buyItemNotInShop);
			this.newsPanel.addEventListener(UIEvent.CLOSE_EVENT,closePanel);
		}
		
		private function closePanel(event:UIEvent):void {
			facade.removeMediator(MEDIATOR_NAME);
		}
		
		private function addMessage(event:UIEvent):void {
			var params:Object = {};
			params.msg = newsPanel.message;
			params.tuid = app_data.currentUser.uid;
			sendNotification(ApplicationFacade.ADD_MESSAGE,params);// 添加完,会再刷新
		}
		
		private function buyItemNotInShop(event:UIEvent):void {
			sendNotification(ApplicationFacade.BUY_ITEM_NOT_IN_SHOP,this.newsPanel);
		}
		
		private function get app_data():AppDataProxy
        {
            return facade.retrieveProxy(AppDataProxy.NAME) as AppDataProxy;
        }
		
		private function showOverlay(event:UIEvent):void {
			sendNotification(ApplicationFacade.SHOW_OVERLAY);
		}
		
		private function hideOverlay(event:UIEvent):void {
			sendNotification(ApplicationFacade.HIDE_OVERLAY);
		}
		
	}
}