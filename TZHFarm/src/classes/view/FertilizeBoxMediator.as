package classes.view
{
	import classes.ApplicationFacade;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tzh.core.Box;
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
		
		override public function listNotificationInterests():Array {
			return [ApplicationFacade.FERTILIZE_BOX_EFFECT,ApplicationFacade.FERTILIZE_BOX_COUNT,ApplicationFacade.BACK_TO_MY_RANCH];
		}
	}
}