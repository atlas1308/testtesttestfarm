package tzh.core
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * 支持一个tooltip的功能
	 */ 
	public class TooltipComponent extends Sprite
	{
		public function TooltipComponent()
		{
			this.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
		}
		
		private function mouseMoveHandler(event:MouseEvent):void {
			this.dispatchEvent(new TooltipEvent(TooltipEvent.SHOW_TOOLTIP));
		}
		
		private function mouseOutHandler(event:MouseEvent):void {
			this.dispatchEvent(new TooltipEvent(TooltipEvent.HIDE_TOOLTIP));
		}
	}
}