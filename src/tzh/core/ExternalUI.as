package tzh.core
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import tzh.UIEvent;
	
	/**
	 * 更新目录到ui里
	 */ 
	public class ExternalUI extends Sprite
	{
		private var _path:String;// 路径
		
		private var loader:Loader;
		
		public function ExternalUI()
		{
			this.load();
		}
		
		public function set path(value:String):void {
			this._path = Config.getConfig("host") + "assets/ui/" + value + ".swf" + "?version=" + Config.getConfig("version");
		}
		
		public function get path():String {
			return this._path;
		}
		
		protected function load():void {
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,completeHandler);
			loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
            loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
            loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
            loader.contentLoaderInfo.addEventListener(Event.OPEN, onOpen);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.DISK_ERROR, onError);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR, onError);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.VERIFY_ERROR, onError);
            var context:LoaderContext = new LoaderContext(true,ApplicationDomain.currentDomain);
            loader.load(new URLRequest(this.path),context);
		}
		
		public function destory():void {
			if(loader){
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,completeHandler);
				loader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
	            loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
	            loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
	            loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
	            loader.contentLoaderInfo.removeEventListener(Event.OPEN, onOpen);
	            loader.contentLoaderInfo.removeEventListener(IOErrorEvent.DISK_ERROR, onError);
	            loader.contentLoaderInfo.removeEventListener(IOErrorEvent.NETWORK_ERROR, onError);
	            loader.contentLoaderInfo.removeEventListener(IOErrorEvent.VERIFY_ERROR, onError);
	            loader.unload();
	            loader = null;
            }
		}
		
		public function getDefinitionByName(name:String):Class {
			var cls:Class = null;
			if(loader && loader.content){
				cls = loader.contentLoaderInfo.applicationDomain.getDefinition(name) as Class
			} 
			return cls;
		}
		
		protected function completeHandler(event:Event):void {
			this.dispatchEvent(event);	
		}
		
		protected function onError(event:IOErrorEvent):void {
			
		}
		
		protected function onOpen(event:Event):void {
			
		}
		
		protected function onProgress(event:ProgressEvent):void {
			
		}
		
		protected function onSecurityError(event:SecurityErrorEvent):void {
			
		}
		
		protected function onHTTPStatus(event:HTTPStatusEvent):void {
			
		}
		
		public function showOverlay():void {
			this.dispatchEvent(new UIEvent(UIEvent.SHOW_OVERLAY));
		}
		
		public function hideOverlay():void {
			this.dispatchEvent(new UIEvent(UIEvent.HIDE_OVERLAY));
		}
	}
}