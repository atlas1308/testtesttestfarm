package tzh.core
{
	import classes.view.components.Map;
	import classes.view.components.Operations;
	import classes.view.components.Shop;
	import classes.view.components.Toolbar;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class TutorialManager extends EventDispatcher
	{
		public function TutorialManager()
		{
			super();
		}
		
		private var currentStep:Object;
		
		private static var instance:TutorialManager;
		
		/**
		 * Hello Farm 向导流程
		 * 先从TZHFarm.instance.stage里获取name为my_ranch的引用,就可以获取到指定的地块了
		 * child[my_ranch] 点击地块要用到的操作
		 * 指定好position即可了
		 * delay是因为有进度条,所以的话,可能会有一些延迟,就是1000ms吧
		 * {id:1,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:18,grid_y:26}},
		 * 以下是向导的整个流程
		 * 
		 */ 
		private var tutorialItems:Array = [
											{id:1,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:13,grid_y:15}},
											{id:2,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:13,grid_y:19}},
											{id:3,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:17,grid_y:16}},
											{id:4,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:17,grid_y:20}},
											{id:5,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:21,grid_y:18}},
											{id:6,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:21,grid_y:22}},
											{id:7,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:21,grid_y:26}},
											{id:8,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:21,grid_y:30}},
											{id:9,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:16,grid_y:37},get:"refill_area",configY:90,offsetY:-3,offsetX:0},// 面板
											{id:10,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:16,grid_y:37},get:"collect_area",configY:90,offsetY:-3,offsetX:5},
											{id:11,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:36,grid_y:16},configY:148,get:"refill_area",offsetX:5},
											{id:12,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:36,grid_y:16},configY:148,get:"collect_area",offsetX:18,offsetY:-28},// 牛 
											
											{id:13,target:":child[toolbar].skinRef.shop",parent:Toolbar,offsetY:-5,autoNext:true},
											
											{id:14,target:":child[shop].itemContainer.child[shopItem0].child[buyButton]",parent:Shop,offsetY:5},
											{id:15,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:38,grid_y:36}}, 
											{id:16,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:34,grid_y:36}}, 
											{id:17,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:30,grid_y:36}}, 
											{id:18,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:38,grid_y:40}},
											{id:19,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:34,grid_y:40}},
											{id:20,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:30,grid_y:40}}, 
											
											{id:21,target:":child[my_ranch]",parent:Map,position:{grid_x:40,grid_y:34},offsetY:15,offsetX:-5},
											
											{id:22,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:38,grid_y:36}}, 
											{id:23,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:34,grid_y:36}}, 
											{id:24,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:30,grid_y:36}}, 
											{id:25,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:38,grid_y:40}},
											{id:26,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:34,grid_y:40}},
											{id:27,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:30,grid_y:40}},  
											
											{id:28,target:":child[toolbar].skinRef.shop",parent:Toolbar,offsetY:-5,autoNext:true},
											{id:29,target:":child[shop].tabContainer.child[shopTab8]",parent:Shop},
											{id:30,target:":child[shop].itemContainer.child[shopItem0].child[buy_rp_btn]",parent:Shop,offsetY:5}, 
											{id:31,target:":child[operations]",parent:Operations,offsetY:17},
											{id:32,target:":child[my_ranch]",parent:Map,delay:100,position:{grid_x:16,grid_y:37},child:"toggler_off",notcheck:true,timeout:0},// 面板
											{id:33,target:":child[my_ranch]",parent:Map,delay:100,position:{grid_x:36,grid_y:16},child:"toggler_off",notcheck:true,timeout:0},// 牛
											{id:34,target:":child[operations]",parent:Operations,offsetY:17}, 
										 ];
		
		public static function getInstance():TutorialManager {
			if( instance == null ){
				instance = new TutorialManager();
			}
			return instance;
		}
		
		private var _frame:int;
		
		private var total:int;
		
		private var _end:Boolean;// 是否结束了
		
		public function get end():Boolean {
			return this._end;
		}
		
		public function set end(value:Boolean):void {
			this._end = value;
		}
		
		private function playNext():void {
			if(tutorialItems.length > 0){
				currentStep = tutorialItems.shift();
				this._frame++;
				TZHFarm.instance.stage.addEventListener(Event.ENTER_FRAME,getTutorialTarget);
			}else {
				this._end = true;
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private var started:Boolean = false;
		public function start():void {
			if(!started){
				this.started = true;
				this.total = tutorialItems.length;
				this._frame = 0;
				this.playNext();
			}
		}
		
		/**
		 * 获取当前运行的帧数
		 */ 
		public function get frame():int {
			return this._frame;
		}
		
		/**
		 * 向导的进度
		 */ 
		public function get progress():Number {
			return this._frame / this.total;
		}
		
		private var _step:ButtonClickStep;
		private function getTutorialTarget(evt:Event):void {
			var target:DisplayObject = this.getTargetObject(currentStep);
			if(target){
				TZHFarm.instance.stage.removeEventListener(Event.ENTER_FRAME,getTutorialTarget);
				_step = new ButtonClickStep(target,currentStep);
				_step.addEventListener(Event.COMPLETE,onCompleted);
				_step.play();
			}
		}
		
		private function getTargetObject(value:Object):DisplayObject {
			var target:String = value.target;
			var splits:Array = target.split(":");
			var parent:Class = value.parent;
			var context:String = splits[1];
			var paths:Array = String(splits[1]).split(".");
			var child:DisplayObjectContainer = ObjectEvaluate.findChildByClass(TZHFarm.instance.stage,parent) as DisplayObjectContainer;
			var result:DisplayObject = null;
			if(child)
			{
				if(!context) {
					return child;
				}
				result = child.getChildByName(context);
			}
			for each(var path:String in paths)
			{
				if(path.indexOf("child[") >= 0)
				{
					var name:String = path.substring(path.indexOf("[") + 1,path.indexOf("]"));
					if(child.name == name){
						result = child;
					}else {
						result = child = child.getChildByName(name) as DisplayObjectContainer;
					}
				}else {
					if(child){
						result = child = child[path];
					}
				}
			}
			var position:Object = value.position;
			if(position){
				result = result["getMapObject"](position.grid_x,position.grid_y);// 获取指定的格子的引用
				if(value.hasOwnProperty("child")){
					result = result["getChildByNameTemp"](value.child);
				}else if(value.hasOwnProperty("get")){
					result = result["getClickAreaByType"](value.get);
				}
			}
			return result;
		}
		
		public function get step():ButtonClickStep {
			return this._step;
		}
		
		private function onCompleted(evt:Event):void {
			//var step:ButtonClickStep = evt.currentTarget as ButtonClickStep;
			step.removeEventListener(Event.COMPLETE,onCompleted);
			this.playNext();
		}
		
	}
}