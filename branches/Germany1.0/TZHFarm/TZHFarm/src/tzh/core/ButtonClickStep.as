package tzh.core
{
	import classes.view.components.Operations;
	import classes.view.components.map.MapObject;
	import classes.view.components.map.Processor;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.clearInterval;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;
	TutorialArrowSkin;
	public class ButtonClickStep extends EventDispatcher
	{
		private var target:*;
		
		private var overlay:Sprite;
		
		public var ARROW_NAME:String = "TutorialArrowSkin";
		
		private var tempParent:DisplayObject;// 这个是解决其它mapObject不能点击的问题
		
		private var baseGridSize:int = 13;// 初始化是13,
		
		public function ButtonClickStep(target:DisplayObject)
		{
			super();
			this.target = target;
			this.tempParent = target.parent;
		}
		
		private var data:Object;
		
		
		public function play(value:Object):void {
			this.data = value;
			this.showArrow();
			var temp:DisplayObject = this.target;
			var notcheck:Boolean = this.data.notcheck;
			var parentAddListener:Boolean;
			if(!notcheck){
				while(temp != null && !(temp is MapObject)){
					temp = temp.parent;
					if(temp is MapObject){
						MapObject(temp).addEventListener(MouseEvent.CLICK,clickHandler);
						parentAddListener = true;
						break;
					}
				}
			}
			if(!parentAddListener){
				this.target.addEventListener(MouseEvent.CLICK,clickHandler);
			}
		}
		
		
		private var clearID:uint = 0;
		private function clickHandler(event:MouseEvent):void {
			var temp:Processor = null;
			if(event.currentTarget is Processor){// 这是为了做一个特殊的处理
				temp = Processor(event.currentTarget);
				var result:Boolean;
				if(this.data.get == Processor.COLLECT_AREA_CONST){
					result = temp.collect_over();
				}else if(this.data.get == Processor.REFILL_AREA_CONST){
					result = temp.refill_over();
				}
				if(!result)return;// 如果没有碰上,就退出了
			}
			var delay:int = this.data.delay;
			this.targetEnabled = false;
			if(delay >= 0){
				clearID = setTimeout(playNext,delay);// 这里可以等待延迟,但是时间不要过长
			}else {
				this.playNext();	
			}
		}
		
		private function playNext():void {
			clearInterval(clearID);
			this.destory();
			this.dispatchEvent(new Event(Event.COMPLETE));
			setTimeout(changeTargetEnabled,250);// 这里解决了一个小问题
		}
		
		public function changeTargetEnabled():void {
			this.targetEnabled = true;
		}
		
		public function set targetEnabled(value:Boolean):void {
			if(this.target.hasOwnProperty("enabled")){
				this.target.enabled = value;
			}
			this.target.mouseChildren = value;
		}
		/**
		 * 这里有可能存在连续播放的情况
		 */ 
		private function showArrow(evt:Event = null):void {
			var stage:Stage = TZHFarm.instance.stage;
			var bounds:Rectangle = this.target.getBounds(stage);
			if(this.target is Operations){
				bounds = Operations(this.target).val.getBounds(stage);
			}
			var hasTutorialArrow:Boolean = stage.getChildByName(ARROW_NAME) != null;
			var arrow:DisplayObject = null;
			if(!hasTutorialArrow){
				var cls:Class = getDefinitionByName(ARROW_NAME) as Class;// 这个mc的注册点在中间
				arrow = new cls() as DisplayObject;
				arrow.name = ARROW_NAME;
				stage.addChild(arrow);
			}else {
				arrow = stage.getChildByName(ARROW_NAME);
			}
			var xx:Number;
			var yy:Number;
			xx = bounds.x + (bounds.width - arrow.width) / 2 + 5;
			yy = bounds.y - bounds.height - arrow.height - 10;
			if(this.target is MapObject){
				xx = bounds.x + (bounds.width - arrow.width) / 2;
				if(this.data.hasOwnProperty("configY")){
					yy = this.data.configY;
				}else {
					yy = bounds.y - bounds.height;
				} 
				this.enabledAllMaps = false;
			}
			var offsetX:int = this.data.offsetX;// 偏移量,X正向左,负向右, Y 正向上,负向下
			var offsetY:int = this.data.offsetY;
			arrow.x = xx - offsetX;
			arrow.y = yy - offsetY;
			if(!overlay){
				overlay = new Sprite();
				overlay.name = "overlay";
				stage.addChildAt(overlay,stage.numChildren);
			} 
			var g:Graphics = overlay.graphics;
			g.clear();
			g.beginFill(0x000000, 0);
			g.drawRect(0, 0, stage.stageWidth,stage.stageHeight);
			g.drawRoundRect(bounds.x,bounds.y,bounds.width,bounds.height,20,20);
			g.endFill(); 
		}
		
		private function set enabledAllMaps(value:Boolean):void {
			var map:Sprite = this.tempParent as Sprite;
			if(!map)return;
			var index:int = 0;
			while(index < map.numChildren){
				var mapObject:MapObject = map.getChildAt(index) as MapObject;
				if(mapObject && mapObject != this.target){
					if(mapObject.mouseChildren != value){
						mapObject.mouseChildren = value;
					}
				}
				index++;
			}  
		}
		
		public function destory():void {
			var stage:Stage = TZHFarm.instance.stage;
			this.enabledAllMaps = true;
			var notcheck:Boolean = this.data.notcheck;
			if(!notcheck){
				var temp:DisplayObject = this.target;
				while(temp != null && !(temp is MapObject)){
					temp = temp.parent;
					if(temp is MapObject){
						MapObject(temp).removeEventListener(MouseEvent.CLICK,clickHandler);
						break;
					}
				}
			}
			if(overlay){
				if(overlay.parent){
					overlay.parent.removeChild(overlay);
				}
				overlay = null;
			}
			var arrow:DisplayObject = TZHFarm.instance.stage.getChildByName(ARROW_NAME);
			if(arrow){
				stage.removeChild(arrow);
			}
			if(this.target.hasEventListener(Event.ENTER_FRAME)){
				this.target.removeEventListener(Event.ENTER_FRAME,showArrow);
			}
			this.target.removeEventListener(MouseEvent.CLICK,clickHandler);
		}
	}
}