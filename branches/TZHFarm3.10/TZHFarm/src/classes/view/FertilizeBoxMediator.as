package classes.view
{
	import classes.ApplicationFacade;
	import classes.model.AppDataProxy;
	
	import mx.resources.ResourceManager;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tzh.UIEvent;
	import tzh.core.Box;
	import tzh.core.FeedData;
	import tzh.core.JSDataManager;
	import tzh.core.TooltipComponentMediator;

	public class FertilizeBoxMediator extends TooltipComponentMediator
	{
		public static const NAME:String = "FertilizeBoxMediator";
		
		public function FertilizeBoxMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		}
		
		public function get box():Box {
			return viewComponent as Box;
		}
		
		override public function onRegister():void {
			super.onRegister();
			this.box.addEventListener(UIEvent.END_EFFECT_POST_FEED,showPostFeedConfirm);
		}
		
		override public function handleNotification(value:INotification):void
		{
			var notificationName:String = value.getName();
			switch(notificationName){
				case ApplicationFacade.FERTILIZE_BOX_EFFECT:
					box.effectLast();
					break;
				case ApplicationFacade.FERTILIZE_BOX_COUNT:
					box.visible = true;
					var obj:Object = value.getBody();
					var times:int = obj ? obj.times : -1;
					box.show(times);
					break;
				case ApplicationFacade.BACK_TO_MY_RANCH:
					box.visible = false;
					break;
				case ApplicationFacade.FERTILIZE_BOX_POST:
					this.postFeedHandler();
					break;
				default:
					break;
			} 
		}
		
		protected function get appDataProxy():AppDataProxy
        {
            return facade.retrieveProxy(AppDataProxy.NAME) as AppDataProxy;
        }
        
        private function showPostFeedConfirm(event:UIEvent):void {
        	var body:Object = {};
        	body.msg = ResourceManager.getInstance().getString("message","share_message_with_friends",[appDataProxy.friend_name]);
        	var obj:Object = {};
        	obj.notif = ApplicationFacade.FERTILIZE_BOX_POST;// 给好友发送post
        	obj.data = ApplicationFacade.FERTILIZE_BOX_POST;
        	body.obj = obj;
        	sendNotification(ApplicationFacade.SHOW_CONFIRM_POPUP,body);
        }
		
		private function postFeedHandler():void {
			var manager:JSDataManager = JSDataManager.getInstance();
			var args:Object = FeedData.getFertilizeToFriendMessage(appDataProxy.user_name,
																		appDataProxy.friend_name,
																		appDataProxy.friend_farm_id);
			manager.postFeed(args);
			var noticeArgs:Object = {};
			noticeArgs.body = args.body;
			noticeArgs.recipients = [appDataProxy.friend_name];
			manager.sendNotice(noticeArgs);
		}
		
		override public function listNotificationInterests():Array {
			return [ApplicationFacade.FERTILIZE_BOX_EFFECT,
				ApplicationFacade.FERTILIZE_BOX_POST,
				ApplicationFacade.FERTILIZE_BOX_COUNT,
				ApplicationFacade.BACK_TO_MY_RANCH];
		}
	}
}