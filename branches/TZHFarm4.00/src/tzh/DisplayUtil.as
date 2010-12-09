package tzh
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	public class DisplayUtil
	{
		public function DisplayUtil()
		{
		}
		
		
		public static function algin(container:DisplayObject,target1:DisplayObject,target2:DisplayObject,hGap:Number = 5):void {
            var ww:Number = target1.width;
        	ww = ww + hGap + target2.width;
        	target1.x = (container.width - ww) / 2;
        	target2.x = target1.x + target1.width + hGap;
        	target2.y = target1.y;
		}
		
		public static function removeAllChildren(container:DisplayObjectContainer):void {
			if(container){
				while(container.numChildren > 0){
					var child:DisplayObject = container.getChildAt(0);
					container.removeChild(child);
				}
			}
		}
		
		public static function removeChild(parent:DisplayObjectContainer,child:DisplayObject):void {
			if(!parent)return;
			if(!child)return;
			if(parent.contains(child)){
				parent.removeChild(child);
			}
			child = null;
		}
		
		public static function center(target:DisplayObject,offsetX:Number = 0,offsetY:Number = 0):void
		{
			var xx:Number = 0;
			var yy:Number = 0;
			if(!target.stage)return;
			xx = (target.stage.stageWidth - target.width) / 2;// 这里先不做空的判断
			yy = (target.stage.stageHeight - target.height) / 2;
			xx += offsetX;
			yy += offsetY;
			target.x = xx;
			target.y = yy;
		}
	}
}