package tzh.core
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * 这里制作一个放大放小的效果
	 * effect之后,默认的都会被移除,暂时不会支持其它的功能
	 * MC的注册点应该在中间
	 */ 
	public class AnimationSprite extends Sprite
	{
		private var target:DisplayObject;// 操作的mc对象
		
		public function AnimationSprite(cls:Class)
		{
			this.target = this.addChild(new cls()) as DisplayObject;
		}
		
		public function effect():void {
			var tween:TweenLite = TweenLite.to(this.target,1,{scaleX:0,scaleY:0,onComplete:completeHandler});// 暂时是这样子简单的效果,可以修改这里
		}
		
		private function completeHandler():void {
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/* private var _tooltip:String;
		
		public function set tooltip(value:String):void {
			this._tooltip = value;
		}
		
		public function get tooltip():String {
			return this._tooltip;
		} */
	}
}