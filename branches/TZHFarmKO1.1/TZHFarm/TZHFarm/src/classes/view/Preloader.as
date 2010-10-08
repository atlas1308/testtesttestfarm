package classes.view
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.ui.ContextMenu;
	import flash.utils.getDefinitionByName;
	
	public class Preloader extends MovieClip
	{
		private var appName:String;
		public var loading:LoadingSkin;
		
		public function Preloader()
		{
			super();
			this.stop();
			this.prevFrame();
			this.appName = currentLabels[1].name;
			this.loading = new LoadingSkin();// 这里的scale9Grid要研究一下
			this.loading.cacheAsBitmap = true;
 			//var rect:Rectangle = this.loading.scale9Grid;// 这个是居中的
			this.loading.x = Math.floor(this.stage.stageWidth) / 2;
			this.loading.y = Math.floor(this.stage.stageHeight) / 2;
			this.loading.scaleX = this.stage.stageWidth / this.loading.width;
			this.loading.scaleY = this.stage.stageHeight / this.loading.height;
			this.addChild(loading);
			this.addEventListener(Event.ENTER_FRAME,checkFrame);
			this.showContextMenu();
		}
		
		private function checkFrame(evt:Event):void {
			var percent:int = Math.floor(this.stage.loaderInfo.bytesLoaded / this.stage.loaderInfo.bytesTotal * 100);
			loading.LoadingBar.gotoAndStop(percent);//检验的时候这里要控制一下
			if(this.totalFrames == this.framesLoaded){
        		this.removeChild(loading);// 删除这个物件,否则会一直显示呢
				this.removeEventListener(Event.ENTER_FRAME,checkFrame);
				this.loadNextFrame();
			} 
		}
		
		private function loadNextFrame():void {
			this.nextFrame();
			var mainClass:Class = Class(getDefinitionByName(appName));
			if(mainClass){
				var app:* = new mainClass();
				var index:int = Math.max(0,this.numChildren - 1);
				addChildAt(app as DisplayObject,index);
			}
		}
		
		private function showContextMenu():void {
			var myContextMenu:ContextMenu = new ContextMenu();
			myContextMenu.hideBuiltInItems();
		    this.contextMenu = myContextMenu;  
		}
	}
}