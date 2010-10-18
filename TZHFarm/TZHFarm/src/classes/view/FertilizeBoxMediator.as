package classes.view
{
	import classes.ApplicationFacade;
	import classes.utils.Cursor;
	
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tzh.core.Box;
	import tzh.core.Config;
	import tzh.core.Constant;

	public class FertilizeBoxMediator extends Mediator
	{
		public static const NAME:String = "FertilizeBoxMediator";
		
		public function FertilizeBoxMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		}
		
		public function get box():Box {
			return viewComponent as Box;
		}
		
		//sendNotification(ApplicationFacade.FERTILIZE_BOX_EFFECT);
		override public function handleNotification(notification:INotification):void
		{
			var notificationName:String = notification.getName();
			switch(notificationName){
				case ApplicationFacade.FERTILIZE_BOX_EFFECT:
					box.effectLast();
					break;
				case ApplicationFacade.FERTILIZE_BOX_COUNT:
					box.visible = true;
					var num:Number = notification.getBody() as Number;
					box.show(num);
					/* var map:Map = facade.retrieveMediator(MapMediator.NAME).getViewComponent() as Map;
					map.set_tool( */
					//Cursor.show(Config.getConfig("host") + Constant.FERTILIZER_CURSOR_PATH,true, 5, 5);
					break;
				case ApplicationFacade.BACK_TO_MY_RANCH:
					box.visible = false;
					break;
				default:
					break;
			}
		}
		
		override public function onRegister():void {
            box.addEventListener(Constant.SHOW_TOOLTIP, showTooltip);
            box.addEventListener(Constant.HIDE_TOOLTIP, hideTooltip);
		}
		
		private function showTooltip(event:Event):void {
			sendNotification(ApplicationFacade.SHOW_TOOLTIP, event.target.tooltip);
		}
		
		private function hideTooltip(event:Event):void {
			sendNotification(ApplicationFacade.HIDE_TOOLTIP);
		}
		
		override public function listNotificationInterests():Array {
			return [ApplicationFacade.FERTILIZE_BOX_EFFECT,ApplicationFacade.FERTILIZE_BOX_COUNT,ApplicationFacade.BACK_TO_MY_RANCH];
		}
	}
}