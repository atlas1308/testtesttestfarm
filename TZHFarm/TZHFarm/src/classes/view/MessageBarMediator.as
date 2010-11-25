package classes.view
{
	import classes.ApplicationFacade;
	import classes.model.AppDataProxy;
	import classes.view.components.messages.NewsPanel;
	
	import flash.display.Stage;
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tzh.UIEvent;

	public class MessageBarMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MessageBarMediator";
		
		public function MessageBarMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		}
		
		public function get messageBar():MessageBar {
			return viewComponent as MessageBar;
		}
		
		override public function listNotificationInterests():Array {
			return [ApplicationFacade.ACTIVATE_SNAPSHOT_MODE, ApplicationFacade.DEACTIVATE_SNAPSHOT_MODE,ApplicationFacade.UPDATE_MSG_COUNT,ApplicationFacade.SHOW_NEWS_PANEL];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var notificationName:String = notification.getName();
			switch(notificationName){
				case ApplicationFacade.ACTIVATE_SNAPSHOT_MODE:
					messageBar.visible = false;
					break;
				case ApplicationFacade.DEACTIVATE_SNAPSHOT_MODE:
					messageBar.visible = true;
					break;
				case ApplicationFacade.UPDATE_MSG_COUNT:
					messageBar.update(notification.getBody());
					break;
				case ApplicationFacade.SHOW_NEWS_PANEL:
					this.showNewsPanel();
					this.messageBar.disabled();
					break;
				default:
					break;
			}
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			this.messageBar.addEventListener(UIEvent.SHOW_NEWS_PANEL,showNewsPanel);
		}
		
		private function showNewsPanel(event:UIEvent = null):void {
			var newsPanel:NewsPanel = new NewsPanel();
			newsPanel.addEventListener(Event.COMPLETE,completeHandler);
		}
		
		private function completeHandler(event:Event):void {
			var newsPanel:NewsPanel = event.currentTarget as NewsPanel;
			var stage:Stage = this.messageBar.stage;
			newsPanel.name = "newsPanel";
			newsPanel.mode = app_data.mode;
			newsPanel.userInfo = app_data.appUser;
        	facade.registerMediator(new NewsPanelMediator(newsPanel));
        	stage.addChild(newsPanel);
        	newsPanel.center();
        	if(app_data.messages && (app_data.messages as Array).length > 0){// 如果有了就不用再继续请求了,就请求一次就可以了
        		sendNotification(ApplicationFacade.UPDATE_NEWS_PANEL);
        	}else {
        		sendNotification(ApplicationFacade.GET_MESSAGE);
        	}
		}
		
		private function get app_data() : AppDataProxy
        {
            return facade.retrieveProxy(AppDataProxy.NAME) as AppDataProxy;
        }
	}
}