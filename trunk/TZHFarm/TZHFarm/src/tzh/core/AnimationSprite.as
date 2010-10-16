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
		
		public function AnimationSprite(target:DisplayObject)
		{
			this.target = target;
		}
		
		public function effect():void {
			var tween:TweenLite = TweenLite.to(this.target,2,{scaleX:0,scaleY:0,
				onComplete:function():void {
					this.dispatchEvent(new Event(Event.COMPLETE));
				}						
			});// 暂时是这样子简单的效果,可以修改这里
		}
	}
}