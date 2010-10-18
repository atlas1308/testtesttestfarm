package classes.view
{
	import classes.ApplicationFacade;
	
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tzh.core.Box;
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
		
		override public function handleNotification(notification:INotification):void
		{
			var notificationName:String = notification.getName();
			switch(notificationName){
				case ApplicationFacade.FERTILIZE_BOX_EFFECT:
					box.effectLast();
					break;
				case ApplicationFacade.FERTILIZE_BOX_COUNT:
					box.visible = true;
					var obj:Object = notification.getBody();
					var times:int = obj ? obj.times : -1;
					box.show(times);
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