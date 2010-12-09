package tzh.core
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
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
	import flash.utils.ByteArray;
	
	/**
	 * 简单的Image没有做任何处理
	 * 只处理了安全水箱的问题
	 * 
	 * 使用方法
	 * 有的时候会有缩放的问题,所以在这里处理了一下,只要传递过来父容器,那么就获取父容器的大小即可
	 * 算出相应的比例
	 * var image:Image = new Image(path,this.parent);
	 * DisplayObject.addChild(image);
	 * set image properties
	 */ 
	public class Image extends Sprite
	{
		private var path:String;// 路径
		
		private var dispatchError:Boolean;
		
		private var parentWidth:Number = 60;
		
		private var parentHeight:Number = 60;
		
		public function Image(path:String,target:DisplayObject,dispatchError:Boolean = true)
		{
			this.path = path;
			var lang:String = Config.getConfig("lang").toString();
			if(this.path.indexOf("http") == -1){
				this.path = Config.getConfig("host") + this.path;
			}
			if(this.path.indexOf("version") == -1){
				this.path += "?version=" + Config.getConfig("version");// 给这些数据加上版本号
			}
			/* if(lang == "de-DE"){
				this.path += "?time=" + new Date().getTime();
			} */
			this.parentWidth = target.width > 0 ? target.width : this.parentWidth;
			this.parentHeight = target.height > 0 ? target.height : this.parentHeight;
			this.dispatchError = dispatchError;
			this.load();	
		}
		
		/**
		 * 默认的会主动加载的
		 */ 
		private function load():void {
			if(!this.path){
				this.onError();
				return;// 没有路径的话,不去加载
			}
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
            loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
            loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
            loader.contentLoaderInfo.addEventListener(Event.OPEN, onOpen);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.DISK_ERROR, onError);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR, onError);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.VERIFY_ERROR, onError);
            var context:LoaderContext = new LoaderContext();
            //context.checkPolicyFile = true;
            /* if (Security.sandboxType == Security.REMOTE){// 只有在加载swf时,才会使用到这个方法, 目前这个只是加载图片
                context.securityDomain = SecurityDomain.currentDomain;
            } */
            context.applicationDomain = ApplicationDomain.currentDomain;
            var request:URLRequest = new URLRequest(path);
            loader.load(request,context);
            this.addChild(loader);
		}
		
		private function onError(evt:IOErrorEvent = null):void {
			trace("load path " + path + " error");
			if(this.dispatchError){
				dispatchEvent(evt);
			}
		}
		
		private function onProgress(evt:ProgressEvent):void {
			
		}
		
		private function onSecurityError(evt:SecurityErrorEvent):void {
			trace("SecurityErrorEvent" + evt.text);
		}
		
		private function onHTTPStatus(evt:HTTPStatusEvent):void {
			
		}
		
		private function onComplete(evt:Event):void {
			var loader:Loader = evt.currentTarget.loader as Loader;
			/* try {
				loader.content;// 没什么具体的作用,访问这个bitmap时,因为是二进制的,所以会出现安全问题,不知道为什么这里加载不上
			}catch(error:Error){
				var context:LoaderContext = new LoaderContext(true,ApplicationDomain.currentDomain);
				loader.loadBytes(loader.contentLoaderInfo.bytes,context);
				trace("SecurityErrorEvent " + error.message); 
				
			} */
			loader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
            loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
            loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
            loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
            loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
            loader.contentLoaderInfo.removeEventListener(Event.OPEN, onOpen);
            loader.contentLoaderInfo.removeEventListener(IOErrorEvent.DISK_ERROR, onError);
            loader.contentLoaderInfo.removeEventListener(IOErrorEvent.NETWORK_ERROR, onError);
            loader.contentLoaderInfo.removeEventListener(IOErrorEvent.VERIFY_ERROR, onError);
            this.calculateScale();
            dispatchEvent(evt);
		}
		
		public function calculateScale(event:Event = null):void {
			var sx:Number = parentWidth / this.width;
			var sy:Number = parentHeight / this.height;
			this.scaleX = sx;
			this.scaleY = sy;
		}
		
		private function onOpen(evt:Event):void {
			// 这里是一个空的方法,暂时还没有用到
		}
	}
}