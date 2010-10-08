package tzh.core
{
	import classes.view.components.Map;
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
											{id:1,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:12,grid_y:32}},
											{id:2,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:12,grid_y:28}},
											{id:3,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:12,grid_y:24}},
											{id:4,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:12,grid_y:20}},
											{id:5,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:18,grid_y:18}},
											{id:6,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:18,grid_y:22}},
											{id:7,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:18,grid_y:26}},
											{id:5,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:29,grid_y:29}},
											{id:5,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:29,grid_y:29}},
											{id:5,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:16,grid_y:40}},
											{id:5,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:16,grid_y:40}}, 
											{id:105,target:":child[toolbar].skinRef.shop",parent:Toolbar},
											{id:106,target:":child[shop].itemContainer.child[shopItem0].child[buyButton]",parent:Shop},
											{id:5,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:45,grid_y:34}}, 
											{id:5,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:45,grid_y:30}}, 
											{id:5,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:45,grid_y:26}}, 
											{id:5,target:":child[my_ranch]",parent:Map,delay:1000,position:{grid_x:45,grid_y:22}}
										 ];
		
		public static function getInstance():TutorialManager {
			if( instance == null ){
				instance = new TutorialManager();
			}
			return instance;
		}
		
		private var _frame:int;
		
		private var total:int;
		
		private function playNext():void {
			if(tutorialItems.length > 0){
				currentStep = tutorialItems.shift();
				this._frame++;
				TZHFarm.instance.stage.addEventListener(Event.ENTER_FRAME,getTutorialTarget);
			}else {
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
		
		private function getTutorialTarget(evt:Event):void {
			var target:DisplayObject = this.getTargetObject(currentStep);
			if(target){
				TZHFarm.instance.stage.removeEventListener(Event.ENTER_FRAME,getTutorialTarget);
				var step:ButtonClickStep = new ButtonClickStep(target);
				step.addEventListener(Event.COMPLETE,onCompleted);
				step.play(currentStep);
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
			}
			return result;
		}
		
		private function onCompleted(evt:Event):void {
			var step:ButtonClickStep = evt.currentTarget as ButtonClickStep;
			step.removeEventListener(Event.COMPLETE,onCompleted);
			this.playNext();
		}
		
	}
}