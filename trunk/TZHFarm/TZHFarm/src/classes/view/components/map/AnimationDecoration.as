package classes.view.components.map
{
	import flash.display.MovieClip;
	
	public class AnimationDecoration extends Decoration
	{
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
				mc.play();
			}
		}
		
	}
}