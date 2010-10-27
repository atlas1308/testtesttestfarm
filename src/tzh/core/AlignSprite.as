package tzh.core
{
	import flash.display.Sprite;

	public class AlignSprite extends Sprite implements IAlign
	{
		public function AlignSprite()
		{
			super();
		}
		
		public function center(offsetX:Number = 0,offsetY:Number = 0):void
		{
			var xx:Number = 0;
			var yy:Number = 0;
			xx = (this.stage.stageWidth - this.width) / 2;
			yy = (this.stage.stageHeight - this.height) / 2;
			xx += offsetX;
			yy += offsetY;
			this.x = xx;
			this.y = yy;
		}
		
	}
}