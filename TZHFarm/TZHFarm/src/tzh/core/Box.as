package tzh.core
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.resources.ResourceManager;
	
	import tzh.UIEvent;

	public class Box extends Sprite
	{
		public var vGap:Number = 5;// 垂直的间隙
		
		public var hGap:Number = 5;// 水平的间隙
		
		private var effectsPool:Array = [];
		
		private var isRunning:Boolean;// 是否正在运行
		
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
				startY = (j + 1)  * (child.height + vGap);
			}
		}
		
		/**
		 * 调用这个方法,来播放效果,暂时只提供从最底下移除的效果
		 */ 
		public function effectLast():void {
			if(!this.hasChildren())return;
			var index:int = Math.max(0,(this.numChildren - (effectsPool.length + 1)));
			var child:DisplayObject = this.getChildAt(index);
			if(child){
				var animationSprite:AnimationSprite = AnimationSprite(child);
				effectsPool.push(animationSprite);
				this.play();
			}
		}
		
		private function play():void {
			if(!isRunning){
				var child:AnimationSprite = effectsPool[0] as AnimationSprite;
				if(child){
					isRunning = true;
					child.addEventListener(Event.COMPLETE,effectComplete);
					child.effect();
				}else {
					trace("started" + isRunning);
				}
			}
		}
		
		/**
		 * 是否还能播放下一个
		 */ 
		public function hasNext():Boolean {
			return effectsPool.length > 0;
		}
		
		/**
		 * 是否还有子级
		 */ 
		public function hasChildren():Boolean {
			return this.numChildren > 0;
		}
		
		private function effectComplete(event:Event):void {
			var child:AnimationSprite = AnimationSprite(event.currentTarget);
			try {
				this.removeChild(child);
			}catch(error:Error){
				trace("remove child error " + error.message); 
			}
			isRunning = false;
			effectsPool.shift();
			if(this.hasNext()){
				this.play();
			}
			if(this.numChildren == 0){
				this.dispatchEvent(new UIEvent(UIEvent.END_EFFECT_POST_FEED));
			}
		}
		
		public var tooltip:String;
		public function show(num:Number = 0):void {
			this.destory();
			var animationSprite:AnimationSprite = null;
			if(isNaN(num) || num <= 0){
				tooltip = "";
				// 这里是绘制不能点的,如果显示提示的话,也可以在这里控制
				animationSprite = new AnimationSprite(FertilizerIcon);
				animationSprite.visible = false;
	            this.addChild(animationSprite);
			}else {
	            for(var i:int = 0; i < num; i++){
	            	tooltip = ResourceManager.getInstance().getString("message","friend_helped_fert_tooltip");
	            	animationSprite = new AnimationSprite(FertilizerIcon);
	            	this.addChild(animationSprite);
	            }
            }
            this.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
            this.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
            this.render(); 
		}
		
		private function mouseMoveHandler(event:MouseEvent):void {
			var target:DisplayObject = event.target as DisplayObject;
			if(target.parent is AnimationSprite){// 
				this.dispatchEvent(new TooltipEvent(TooltipEvent.SHOW_TOOLTIP));
			}
		}
		
		private function mouseOutHandler(event:MouseEvent):void {
			this.dispatchEvent(new TooltipEvent(TooltipEvent.HIDE_TOOLTIP));
		}
		
		public function destory():void {
			this.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
            this.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			while(this.numChildren > 0){
				this.removeChildAt(0);
			}
		}
	}
}