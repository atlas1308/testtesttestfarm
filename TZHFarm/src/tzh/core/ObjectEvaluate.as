package tzh.core
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class ObjectEvaluate
	{
		public function ObjectEvaluate()
		{
		}
		
		public static function findChildByClass(container:*,cls:Class):DisplayObject
		{
			if(container is cls){
				return container;
			}
			for(var i:int; i<container.numChildren;i++)
			{
				var child:DisplayObject = container.getChildAt(i);
				
				if(child is cls)
				{
					return child;
				}
			}
			return null;
		}
	}
}