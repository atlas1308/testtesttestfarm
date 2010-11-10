package tzh.core
{
	import classes.ApplicationFacade;
	
	import flash.display.DisplayObject;
	
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tzh.core.TooltipEvent;

	public class TooltipComponentMediator extends Mediator
	{
		public function TooltipComponentMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
		}
		
		override public function onRegister():void {
			DisplayObject(this.viewComponent).addEventListener(TooltipEvent.SHOW_TOOLTIP,showTooltipHandler);
			DisplayObject(this.viewComponent).addEventListener(TooltipEvent.HIDE_TOOLTIP,hideTooltipHandler);
		}
		
		private function showTooltipHandler(event:TooltipEvent):void {
			sendNotification(ApplicationFacade.SHOW_TOOLTIP,event.target.tooltip);
		}
		
		private function hideTooltipHandler(event:TooltipEvent):void {
			sendNotification(ApplicationFacade.HIDE_TOOLTIP);
		}
	}
}