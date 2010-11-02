package tzh
{
	import flash.display.DisplayObject;
	
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
	}
}