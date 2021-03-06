package tzh.core
{
	import classes.view.components.Map;
	import classes.view.components.Operations;
	import classes.view.components.Shop;
	import classes.view.components.map.MapObject;
	import classes.view.components.map.Processor;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.utils.clearInterval;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;
	TutorialArrowSkin;
	public class ButtonClickStep extends EventDispatcher
	{
		/**
		 * 通过Map点击的事件,发送到这里
		 */ 
		private var target:*;
		
		private var overlay:Sprite;
		
		public var ARROW_NAME:String = "TutorialArrowSkin";
		
		private var tempParent:DisplayObject;// 这个是解决其它mapObject不能点击的问题
		
		public function ButtonClickStep(target:DisplayObject,value:Object)
		{
			super();
			this.target = target;
			this.tempParent = target.parent;
			this.data = value;
			this.configEventListener();
		}
		
		private var data:Object;
		
		public function play():void {
			this.showArrow();
		}
		
		/**
		 * 如果是种植物,如果点击了,但是没有执行clickHandler事件,
		 * 那么显示对象应该被kill掉了,所以会出现点不上的现象
		 * 
		 */ 
		private function configEventListener():void {
			TZHFarm.instance.stage.mouseChildren = false;
			var temp:MapObject = this.getProcessor(false);
			if(temp != null && temp is Processor){
				temp.addEventListener(MouseEvent.CLICK,clickHandler);
			}else {
				var autoNext:Boolean = this.data.autoNext;
				if(this.target is MapObject || autoNext){
					this.check();
				}
				this.target.addEventListener(MouseEvent.CLICK,clickHandler);
			}
			TZHFarm.instance.stage.mouseChildren = true;
		}
		
	
		
		/**
		 * 获取Mill,Cow等MapObject
		 * @param checkabled:Boolean 如果是true的话,就默认的能获取到这个MapObject,即使在TutorialManager里配置
		 */ 
		private function getProcessor(checkabled:Boolean):MapObject {
			var notcheck:Boolean = this.data.notcheck;
			var result:MapObject;
			var temp:DisplayObject = this.target;
			if(!notcheck || checkabled){// 有些在mapObject上的按纽是不用check的
				while(temp != null){
					if(!(temp is MapObject)){
						temp = temp.parent;
						if(temp is MapObject){
							result = MapObject(temp);
							break;
						}
					}else {
						result = MapObject(temp);
						break;
					}
				}
			}
			return result;
		}
		
		private var clearID:uint = 0;
		
		/**
		 * 
		 */ 
		private function clickHandler(event:MouseEvent):void {
			var delay:int = this.data.delay;
			if(delay > 0 && clearID != 0)return;// 说明已经点击过了
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
			this.targetEnabled = false;
			if(delay > 0){
				clearID = setTimeout(playNext,delay);// 这里可以等待延迟,但是时间不要过长
			}else {
				this.playNext();	
			}
		}
		
		private function playNext():void {
			clearInterval(clearID);
			this.complete();
			this.targetEnabled = true;
		}
		
		private function complete():void {
			this.destory();
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * 设置当前的点击对象,是否可以点
		 */ 
		public function set targetEnabled(value:Boolean):void {
			if(this.target.hasOwnProperty("enabled")){
				this.target.enabled = value;
			}
			this.target.mouseChildren = value;
		}
		
		/**
		 * 
		 */ 
		private function enabledTimeout():void {
			var processor:MapObject = this.getProcessor(true);
			if(this.target is MapObject || processor is MapObject){
				this.enabledAllMaps = false;
			}
		}
		
		private var timer:Timer;
		private function check():void {
			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER,timerHandler);
			timer.start();
		}
		
		private function timerHandler(event:TimerEvent):void {
			var temp:MapObject = this.getProcessor(false);
			var autoNext:Boolean = this.data.autoNext;
			if(temp != null && !(temp is Processor) ){// 这里是容错处理,因为target已经被切换了
				var map:Map = TZHFarm.instance.stage.getChildByName("my_ranch") as Map;
				var position:Object = this.data.position;
				var mapObject:MapObject = map.getMapObject(position.grid_x,position.grid_y);
				if(!mapObject.same(this.target)){
					trace("autoCheck bug");
					this.target = mapObject;
					this.complete();
				}
			}else if(autoNext){
				var shop:Shop = TZHFarm.instance.stage.getChildByName("shop") as Shop;
				if(shop.visible){
					trace("autoCheck bug");
					this.complete();
				} 
			}
		}
		
		/**
		 * 这里有可能存在连续播放的情况
		 */ 
		private var enabledID:uint;
		private function showArrow(evt:Event = null):void {
			var stage:Stage = TZHFarm.instance.stage;
			var bounds:Rectangle = this.target.getBounds(stage);
			if(this.target is Operations){
				bounds = Operations(this.target).val.getBounds(stage);
			}
			var hasTutorialArrow:Boolean = stage.getChildByName(ARROW_NAME) != null;
			var arrow:DisplayObject = null;
			if(hasTutorialArrow){
				stage.removeChild(stage.getChildByName(ARROW_NAME));
				trace("remove tutorial arrow");
			}
			var cls:Class = getDefinitionByName(ARROW_NAME) as Class;// 这个mc的注册点在中间
			arrow = new cls() as DisplayObject;
			arrow.name = ARROW_NAME;
			stage.addChild(arrow);
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
			var xx:Number;
			var yy:Number;
			xx = bounds.x + (bounds.width - arrow.width) / 2 + 5;
			yy = bounds.y - bounds.height - arrow.height - 10;
			var timeout:int = 500;
			if(this.data.hasOwnProperty("timeout")){
				timeout = this.data.timeout;
			}
			enabledID = setTimeout(enabledTimeout,timeout);
			if(this.target is MapObject){
				xx = bounds.x + (bounds.width - arrow.width) / 2;
				if(this.data.hasOwnProperty("configY")){
					yy = this.data.configY;
				}else {
					yy = bounds.y - bounds.height;
				}
			}
			var offsetX:int = this.data.offsetX;// 偏移量,X正向左,负向右, Y 正向上,负向下
			var offsetY:int = this.data.offsetY;
			arrow.x = xx - offsetX;
			arrow.y = yy - offsetY;
			
		}
		
		/**
		 * 
		 */ 
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
			var processor:MapObject = this.getProcessor(true);
			if(this.target is MapObject){
				this.target.mouseChildren = true;
			}else if(processor){// 这里主要是Mill Cow显示上的东西,target是它的子级,所以要判断一下
				processor.mouseChildren = true;
			}
		}
		
		/**
		 * 
		 */ 
		public function removeOverlay():void {
			if(overlay){
				if(overlay.parent){
					overlay.parent.removeChild(overlay);
				}
				overlay = null;
			}
		}
		
		/**
		 * 
		 */ 
		public function destory():void {
			var stage:Stage = TZHFarm.instance.stage;
			var temp:MapObject = this.getProcessor(false);
			if(temp != null && temp is Processor){
				temp.removeEventListener(MouseEvent.CLICK,clickHandler);
			}else {
				this.target.removeEventListener(MouseEvent.CLICK,clickHandler);
			} 
			this.removeOverlay();
			var arrow:DisplayObject = TZHFarm.instance.stage.getChildByName(ARROW_NAME);
			if(arrow){
				stage.removeChild(arrow);
			}
			if(this.target.hasEventListener(Event.ENTER_FRAME)){
				this.target.removeEventListener(Event.ENTER_FRAME,showArrow);
			}
			if(timer){
				timer.stop();
				timer.addEventListener(TimerEvent.TIMER,timerHandler);
				timer = null;
			}
			clearInterval(enabledID);
		}
	}
}