package classes.view.components.map
{
	import flash.display.MovieClip;
	
	public class AnimationDecoration extends Decoration
	{
		public static const ROTATION_0:int = 1;
		public static const ROTATION_180:int = 2;
		
		public function AnimationDecoration(value:Object)
		{
			super(value);
		}
		
		override protected function init():void {
			super.init();
			loader.cache_swf = true;
		}
		
		override protected function add_asset():void {
			if(loader.loader && loader.loader.content && loader.loader.content is MovieClip){
				var mc:MovieClip = loader.loader.content as MovieClip;
				mc.cacheAsBitmap = true;
				asset.addChildAt(mc, 0);
				var frame:int = getRotation(flipped != 0);
				mc.gotoAndStop(frame);
			}
		}
		
		/**
		 * 游戏里的反转只实现2个面的转换即可
		 */ 
		public function getRotation(flag:Boolean):int {
			var result:int;
			if(flag){
				result = ROTATION_180;
			}else {
				result = ROTATION_0;
			}
			return result;
		}
		
		/**
		 * 只有在点击的时候才能这样操作
		 */ 
		override public function flip(animationable:Boolean = false):void {
			super.flipAnimation();
			if(animationable){
				var frame:int = getRotation(mc.currentFrame == ROTATION_0);;
				mc.gotoAndStop(frame);
			}	
		}	
		
		/**
		 * 这个和原来的实现方式有了很大的改变
		 */ 
		override public function is_flipped():Boolean {
			var result:Boolean = false;
			var mc:MovieClip = super.mc;
			if(mc && mc.currentFrame == ROTATION_180){
				result = true;
			}
			return result;
		}
	}
}