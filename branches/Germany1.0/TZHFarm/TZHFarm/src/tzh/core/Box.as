package tzh.core
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	public class Box extends Sprite
	{
		public var vGap:Number = 5;// 垂直的间隙
		
		public var hGap:Number = 5;// 水平的间隙
		
		private var effectsPool:Array = [];
		
		public function Box()
		{
			super();
		}
		
		
		/**
		 * 重绘的时候调用这个方法
		 */ 
		public function render():void {
			var numChildren:int = this.numChildren;
			var startX:Number = 0;
			var startY:Number = 0;
			var child:DisplayObject = null;
			for(var j:int = 0; j < numChildren; j++){
				child = this.getChildAt(j);
				child.y = startY;
				startY += (j + 1) * child.height + vGap;
			}
		}
		
		private var isRunning:Boolean;// 是否正在运行
		
		private var effectTimes:int;// 更新效果的次数,如果直接this.numChildren,有可能因为效果没执行,而this.numChildren不会有变化 
		
		public function effectLast():void {
			effectTimes++;
			var index:int = Math.max(0,(this.numChildren - effectTimes));
			var child:DisplayObject = this.getChildAt(index);
			if(child){
				var animationSprite:AnimationSprite = AnimationSprite(child);
				var isExistInPool:Boolean = effectsPool.indexOf(child) >= 0;
				if(!isExistInPool){
					effectsPool.push(child);
				}
				this.play(child);
			}
		}
		
		private function play(child:AnimationSprite):void {
			if(child && !isRunning){
				isRunning = true;
				child.addEventListener(Event.COMPLETE,effectComplete);
				child.effect();
			}else {
				trace("started" + isRunning);
			}
		}
		
		private function effectComplete(event:Event):void {
			var child:AnimationSprite = AnimationSprite(event.currentTarget);
			try {
				this.removeChild(child);
			}catch(error:Error){
				trace("remove child error " + error.message); 
			}
			isRunning = false;
			effectTimes--;
			this.effectLast();
		}
	}
}